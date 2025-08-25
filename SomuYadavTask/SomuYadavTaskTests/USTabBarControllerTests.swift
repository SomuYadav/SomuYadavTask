//
//  USTabBarControllerTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

@MainActor
final class USTabBarControllerTests: XCTestCase {
    func test_viewDidLoad_setsControllers_andDefaultSelection() {
        let tabs = USTabBarController()
        _ = tabs.view

        XCTAssertEqual(tabs.viewControllers?.count, 5)
        XCTAssertEqual(tabs.selectedIndex, 2)
        tabs.moveSelectionIndicator(to: 0, animated: false)
        tabs.viewDidLayoutSubviews()
    }
}
