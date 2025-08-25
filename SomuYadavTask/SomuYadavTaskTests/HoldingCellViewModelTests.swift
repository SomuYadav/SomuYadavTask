//
//  HoldingCellViewModelTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask

final class HoldingCellViewModelTests: XCTestCase {
    func test_properties_renderExpectedStrings() {
        let h = Holding(symbol: "TCS", quantity: 4, ltp: 12, avgPrice: 10, close: 11)
        let vm = HoldingCellViewModel(holding: h)
        XCTAssertEqual(vm.symbolText, "TCS")
        XCTAssertEqual(vm.netQuantityText.string, "Net Qty: 4")
        XCTAssertTrue(vm.ltpText.string.contains("LTP "))
        XCTAssertTrue(vm.pnlText.string.contains("P&L "))
        XCTAssertEqual(vm.pnlValue, (12 - 10) * 4, accuracy: 0.001)
        XCTAssertTrue(vm.isGain)
    }
}
