//
//  HoldingsRepositoryTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask

final class HoldingsRepository_ExtraTests: XCTestCase {
    struct APIStub: APIClientType {
        let result: Result<[Holding], Error>
        func fetchHoldings() async throws -> [Holding] { try result.get() }
    }
    final class StoreSpy: HoldingsStoreType {
        var saved: [Holding] = []
        var toLoad: [Holding] = []
        func save(_ holdings: [Holding]) throws { saved = holdings }
        func load() throws -> [Holding] { toLoad }
    }

    func test_fetch_remoteFirstFalse_prefersCache() async throws {
        let store = StoreSpy()
        store.toLoad = [Holding(symbol: "C", quantity: 1, ltp: 1, avgPrice: 1, close: 1)]
        let repo = HoldingsRepository(apiClient: APIStub(result: .success([])), store: store)
        let got = try await repo.fetch(remoteFirst: false)
        XCTAssertEqual(got, store.toLoad)
    }
}
