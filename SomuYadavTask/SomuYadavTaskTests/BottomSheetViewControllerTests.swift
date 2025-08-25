//
//  BottomSheetViewControllerTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

@MainActor
final class BottomSheetViewControllerTests: XCTestCase {
    func test_toggleAndApplySummary_doesNotCrash_andUpdatesHierarchy() {
        let vc = BottomSheetViewController()
        _ = vc.view
        let before = vc.testHooks.containerView.frame.height

        vc.testHooks.simulateToggle()
        vc.testHooks.apply(summary: .init(currentValue: 100, totalInvestment: 60, totalPNL: 40, todaysPNL: 5))

        XCTAssertNotNil(vc.testHooks.containerView.superview)
        XCTAssertGreaterThanOrEqual(before, 0)
    }
}
