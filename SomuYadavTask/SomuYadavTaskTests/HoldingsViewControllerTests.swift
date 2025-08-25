//
//  HoldingsViewControllerTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

@MainActor
final class HoldingsViewControllerTests: XCTestCase {
    struct APIStub: APIClientType {
        let result: Result<[Holding], Error>
        func fetchHoldings() async throws -> [Holding] { try result.get() }
    }
    final class StoreSpy: HoldingsStoreType {
        func save(_ holdings: [Holding]) throws {}
        func load() throws -> [Holding] { [] }
    }

    func test_segTap_updatesVMSelectedSegment_andReloads() async {
        let api = APIStub(result: .success([]))
        let repo = HoldingsRepository(apiClient: api, store: StoreSpy())
        let vm = HoldingsViewModel(repository: repo)
        let vc = HoldingsViewController(viewModel: vm)

        _ = vc.view
        vc.viewDidLayoutSubviews()

        // initial
        XCTAssertEqual(vm.selectedSegment, .holdings)

        // simulate tap to positions
        vc.testHooks.simulateSegmentTap(index: 0)
        XCTAssertEqual(vm.selectedSegment, .positions)

        // tableView exists
        XCTAssertNotNil(vc.testHooks.bottomSheet)
        XCTAssertEqual(vc.testHooks.tableView.numberOfSections, 1)
    }
}
