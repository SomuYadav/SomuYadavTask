//
//  BottomSheetPassthroughViewTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask
import UIKit

@MainActor
final class BottomSheetPassthroughViewTests: XCTestCase {
    func test_pointInside_onlyForHitTarget() {
        let host = BottomSheetPassthroughView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let target = UIView(frame: CGRect(x: 10, y: 10, width: 80, height: 30))
        host.addSubview(target)
        host.hitTarget = target

        XCTAssertTrue(host.point(inside: CGPoint(x: 20, y: 20), with: nil))
        XCTAssertFalse(host.point(inside: CGPoint(x: 50, y: 90), with: nil))
    }
}
