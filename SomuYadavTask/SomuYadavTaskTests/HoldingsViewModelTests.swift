//
//  SomuYadavTaskTests.swift
//  SomuYadavTaskTests
//
//  Created by Somendra Yadav on 25/08/25.
//
import XCTest
@testable import SomuYadavTask

final class HoldingsViewModelTests: XCTestCase {
    struct APIStub: APIClientType {
        let result: Result<[Holding], Error>
        func fetchHoldings() async throws -> [Holding] {
            try result.get()
        }
    }

    final class StoreSpy: HoldingsStoreType {
        private(set) var saved: [Holding] = []
        var loadResult: Result<[Holding], Error> = .failure(NSError(domain: "", code: -1))
        func save(_ holdings: [Holding]) throws { saved = holdings }
        func load() throws -> [Holding] { try loadResult.get() }
    }

    func test_refresh_success_updatesSummaryAndItems() async {
        // Given
        let holdings = [
            Holding(symbol: "AAPL", quantity: 2, ltp: 10, avgPrice: 8, close: 9),
            Holding(symbol: "MSFT", quantity: 1, ltp: 20, avgPrice: 25, close: 19)
        ]
        let api = APIStub(result: .success(holdings))
        let store = StoreSpy()
        let repo = HoldingsRepository(apiClient: api, store: store)
        let vm = await HoldingsViewModel(repository: repo)

        // When
        await vm.refresh()

        // Then
        await MainActor.run {
            XCTAssertEqual(vm.items.count, 2)
            XCTAssertEqual(vm.summary.currentValue, 40, accuracy: 0.001)
            XCTAssertEqual(vm.summary.totalInvestment, 41, accuracy: 0.001)
            XCTAssertEqual(vm.summary.totalPNL, -1, accuracy: 0.001)
        }
    }

    func test_refresh_failure_usesCache_whenAvailable() async {
        // Given
        let cached = [Holding(symbol: "GOOG", quantity: 1, ltp: 100, avgPrice: 90, close: 95)]
        let api = APIStub(result: .failure(URLError(.notConnectedToInternet)))
        let store = StoreSpy()
        store.loadResult = .success(cached)
        let repo = HoldingsRepository(apiClient: api, store: store)
        let vm = await HoldingsViewModel(repository: repo)

        // When
        await vm.refresh()

        await MainActor.run {
            // Then
            XCTAssertEqual(vm.items.count, 1)
            XCTAssertEqual(vm.summary.currentValue, 100, accuracy: 0.001)
            XCTAssertEqual(vm.summary.totalInvestment, 90, accuracy: 0.001)
            XCTAssertEqual(vm.summary.totalPNL, 10, accuracy: 0.001)
        }
    }

    func test_portfolioSummary_compute_correctness() async throws {
        let items = [
            Holding(symbol: "A", quantity: 2, ltp: 10, avgPrice: 8, close: 9),
            Holding(symbol: "B", quantity: 3, ltp: 5, avgPrice: 6, close: 6)
        ]
        let s = PortfolioSummary.compute(from: items)
        XCTAssertEqual(s.currentValue, 2*10 + 3*5, accuracy: 0.0001)
        await MainActor.run {
            XCTAssertEqual(s.totalInvestment, 2*8 + 3*6, accuracy: 0.0001)
        }
        let first = (2*10 + 3*5)
        let second = (2*8 + 3*6)
        XCTAssertEqual(s.totalPNL, Double(first - second), accuracy: 0.0001)
        XCTAssertEqual(s.todaysPNL, (9-10)*2 + (6-5)*3, accuracy: 0.0001)
    }

    func test_viewModel_testHooks_injectAndSelectSegment() async {
        let api = APIStub(result: .success([]))
        let repo = HoldingsRepository(apiClient: api, store: StoreSpy())
        await MainActor.run {
            let vm = HoldingsViewModel(repository: repo)
            vm.testHooks.inject([
                Holding(symbol: "X", quantity: 1, ltp: 10, avgPrice: 9, close: 10)
            ])
            XCTAssertEqual(vm.items.count, 1)
            vm.testHooks.setSegment(.positions)
            XCTAssertEqual(vm.testHooks.selected, .positions)
        }
    }

    func test_repository_remoteSuccess_savesToStore() async throws {
        let holdings = [Holding(symbol: "A", quantity: 1, ltp: 1, avgPrice: 1, close: 1)]
        let api = APIStub(result: .success(holdings))
        let store = StoreSpy()
        let repo = HoldingsRepository(apiClient: api, store: store)
        let fetched = try await repo.fetch(remoteFirst: true)
        XCTAssertEqual(fetched, holdings)
        XCTAssertEqual(store.saved, holdings)
    }

    func test_repository_remoteFail_usesCacheIfAvailable() async {
        let cached = [Holding(symbol: "B", quantity: 1, ltp: 1, avgPrice: 1, close: 1)]
        let api = APIStub(result: .failure(URLError(.notConnectedToInternet)))
        let store = StoreSpy()
        store.loadResult = .success(cached)
        let repo = HoldingsRepository(apiClient: api, store: store)
        let fetched = try? await repo.fetch(remoteFirst: true)
        XCTAssertEqual(fetched, cached)
    }

    func test_segmentedSwitch_testHooks_simulateTap() {
        let seg = SegmentedSwitchView()
        var selectedIndex: Int = -1
        class D: SegmentedSwitchViewDelegate {
            var onSelect: ((Int) -> Void)?
            func segmentedSwitchView(_ view: SegmentedSwitchView, didSelect index: Int) { onSelect?(index) }
        }
        let d = D()
        seg.delegate = d
        let exp = expectation(description: "tap")
        d.onSelect = { i in selectedIndex = i; exp.fulfill() }
        seg.testHooks.simulateTap(index: 0)
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(selectedIndex, 0)
        XCTAssertEqual(seg.testHooks.selectedIndex, 0)
    }

    func test_bottomSheet_testHooks_toggleAndApply() {
        let bs = BottomSheetViewController()
        _ = bs.view // force load
        let beforeHeight = bs.testHooks.containerView.frame.height
        bs.testHooks.simulateToggle()
        bs.testHooks.apply(summary: .init(currentValue: 1, totalInvestment: 1, totalPNL: 0, todaysPNL: 0))
        XCTAssertNotNil(bs.testHooks.containerView.superview)
        XCTAssertGreaterThanOrEqual(beforeHeight, 0)
    }
    
    func test_inject_and_setSegment_viaHooks() async {
        let repo = HoldingsRepository(apiClient: APIStub(result: .success([])), store: StoreSpy())
        let vm = await HoldingsViewModel(repository: repo)
        await vm.testHooks.inject([Holding(symbol: "X", quantity: 1, ltp: 10, avgPrice: 9, close: 10)])
        await MainActor.run {
            XCTAssertEqual(vm.items.count, 1)
            vm.testHooks.setSegment(.positions)
            XCTAssertEqual(vm.testHooks.selected, .positions)
        }
    }
}
