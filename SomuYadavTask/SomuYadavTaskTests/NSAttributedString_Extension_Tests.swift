//
//  NSAttributedString_Extension_Tests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

final class NSAttributedString_Extension_Tests: XCTestCase {
    func test_getAttributedString_colorsRanges() {
        let s = NSAttributedString.getAttributedString(leftString: "Net Qty", rightString: "10", rightStringColor: .systemGreen)
        let full = s.string
        XCTAssertEqual(full, "Net Qty: 10")

        let leftColor = s.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        let rightColor = s.attribute(.foregroundColor, at: "Net Qty: ".count, effectiveRange: nil) as? UIColor

        XCTAssertEqual(leftColor, .gray)
        XCTAssertEqual(rightColor, .systemGreen)
    }
}
