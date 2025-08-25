//
//  SegmentedSwitchViewTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

@MainActor
final class SegmentedSwitchViewTests: XCTestCase {
    func test_defaultSelection_isHoldings() {
        let seg = SegmentedSwitchView()
        seg.layoutIfNeeded()
        XCTAssertEqual(seg.testHooks.selectedIndex, 1)
    }

    func test_simulateTap_notifiesDelegateAndUpdatesSelection() {
        let seg = SegmentedSwitchView()
        class D: SegmentedSwitchViewDelegate {
            var onSelect: ((Int) -> Void)?
            func segmentedSwitchView(_ view: SegmentedSwitchView, didSelect index: Int) { onSelect?(index) }
        }
        let d = D()
        seg.delegate = d
        let exp = expectation(description: "tap")
        var got = -1
        d.onSelect = { i in got = i; exp.fulfill() }

        seg.testHooks.simulateTap(index: 0)

        wait(for: [exp], timeout: 1)
        XCTAssertEqual(got, 0)
        XCTAssertEqual(seg.testHooks.selectedIndex, 0)
    }
}
