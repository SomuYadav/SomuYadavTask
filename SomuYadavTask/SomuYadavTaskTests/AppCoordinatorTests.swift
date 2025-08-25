//
//  AppCoordinatorTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

@MainActor
final class AppCoordinatorTests: XCTestCase {
    func test_start_setsRootToNavWithTabs() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = AppCoordinator(window: window)

        coordinator.start()

        let nav = window.rootViewController as? UINavigationController
        XCTAssertNotNil(nav, "Root should be UINavigationController")
        XCTAssertTrue(nav?.viewControllers.first is USTabBarController, "Root VC should be USTabBarController")
    }
}
