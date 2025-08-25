//
//  AppAppearanceTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

final class AppAppearanceTests: XCTestCase {
    func test_setupAppearance_doesNotCrash() {
        AppAppearance.setupAppearance()
        XCTAssertTrue(true)
    }
}
