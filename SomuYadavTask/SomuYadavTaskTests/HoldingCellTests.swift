//
//  HoldingCellTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

@MainActor
final class HoldingCellTests: XCTestCase {
    var cell: HoldingCell!

    override func setUpWithError() throws {
        try super.setUpWithError()
        cell = HoldingCell(style: .default, reuseIdentifier: HoldingCell.reuseIdentifier)
    }

    override func tearDownWithError() throws {
        cell = nil
        try super.tearDownWithError()
    }

    func test_apply_setsLabels() {
        let h = Holding(symbol: "AAPL", quantity: 2, ltp: 10, avgPrice: 8, close: 9)
        let vm = HoldingCellViewModel(holding: h)
        cell.apply(viewModel: vm)

        XCTAssertEqual(cell.stockLabel.text, "AAPL")
        XCTAssertEqual(cell.netQtyLabel.attributedText?.string, "Net Qty: 2")
        XCTAssertTrue(cell.ltpLabel.attributedText?.string.contains("LTP ") ?? false)
        XCTAssertTrue(cell.profitAndLossLabel.attributedText?.string.contains("P&L ") ?? false)
    }
}
