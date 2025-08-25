//
//  HoldingTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask

final class HoldingTests: XCTestCase {
    func test_decode_supportsAlternateKeys() throws {
        let json = """
        {
          "symbol":"X",
          "qty":"2",
          "lastTradedPrice": "10",
          "averagePrice": 8,
          "prevClose": 9
        }
        """.data(using: .utf8)!
        let h = try JSONDecoder().decode(Holding.self, from: json)
        XCTAssertEqual(h.symbol, "X")
        XCTAssertEqual(h.quantity, 2)
        XCTAssertEqual(h.ltp, 0.0)
        XCTAssertEqual(h.avgPrice, 8)
        XCTAssertEqual(h.close, 9)
    }

    func test_encode_roundTrips() throws {
        let h = Holding(symbol: "A", quantity: 1, ltp: 2, avgPrice: 3, close: 4)
        let data = try JSONEncoder().encode(h)
        let back = try JSONDecoder().decode(Holding.self, from: data)
        XCTAssertEqual(h, back)
    }
}
