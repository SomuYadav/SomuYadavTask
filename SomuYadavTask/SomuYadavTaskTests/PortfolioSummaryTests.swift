//
//  PortfolioSummaryTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask

final class PortfolioSummaryTests: XCTestCase {
    func test_compute_sumsCorrectly() {
        let hs = [
            Holding(symbol: "A", quantity: 2, ltp: 10, avgPrice: 8, close: 9),
            Holding(symbol: "B", quantity: 3, ltp: 5,  avgPrice: 6, close: 6)
        ]
        let s = PortfolioSummary.compute(from: hs)
        XCTAssertEqual(s.currentValue, 2*10 + 3*5, accuracy: 0.001)
        XCTAssertEqual(s.totalInvestment, 2*8 + 3*6, accuracy: 0.001)
        let first = (2*10 + 3*5)
        let second = (2*8 + 3*6)
        XCTAssertEqual(s.totalPNL, Double(first - second), accuracy: 0.001)
        XCTAssertEqual(s.todaysPNL, (9-10)*2 + (6-5)*3, accuracy: 0.001)
    }
}
