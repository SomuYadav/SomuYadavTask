//
//  TagLabelViewTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

@MainActor
final class TagLabelViewTests: XCTestCase {
    func test_setText_setsLabelText() {
        let v = TagLabelView()
        v.testHooks.set(text: "T1 Holding")
        let label = v.subviews.compactMap { $0 as? UILabel }.first
        XCTAssertEqual(label?.text, "T1 Holding")
        XCTAssertEqual(v.backgroundColor, UIColor.lightGray.withAlphaComponent(0.5))
        XCTAssertEqual(v.layer.cornerRadius, 4)
        XCTAssertTrue(v.clipsToBounds)
    }
}
