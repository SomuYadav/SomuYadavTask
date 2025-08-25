//
//  HoldingsStoreTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask

final class HoldingsStoreTests: XCTestCase {
    func test_save_and_load_roundTrip() throws {
        let filename = "holdings_cache_test_\(UUID().uuidString).json"
        let store = HoldingsStore(filename: filename)
        let sample = [Holding(symbol: "Z", quantity: 2, ltp: 3, avgPrice: 1, close: 2)]

        try store.save(sample)
        let loaded = try store.load()
        XCTAssertEqual(sample, loaded)
    }
}
