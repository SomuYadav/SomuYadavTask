//
//  PositionCellTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

@MainActor
final class PositionCellTests: XCTestCase {
    func test_apply_setsSymbolAndNetQty() {
        let cell = PositionCell(style: .default, reuseIdentifier: PositionCell.reuseIdentifier)
        let h = Holding(symbol: "MSFT", quantity: 3, ltp: 2, avgPrice: 1, close: 1)
        let vm = HoldingCellViewModel(holding: h)

        cell.apply(viewModel: vm)

        XCTAssertEqual(cell.testHooks.symbol, "MSFT")
        XCTAssertEqual(cell.testHooks.netQty?.string, "Net Qty: 3")
    }
}
