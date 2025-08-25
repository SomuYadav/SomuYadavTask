//
//  Untitled.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

/// Forwards touches only to `hitTarget` (the visible rounded sheet).
/// Touches outside pass through to underlying views (table/segmented).
final class BottomSheetPassthroughView: UIView {
    weak var hitTarget: UIView?
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let target = hitTarget else { return false }
        let p = convert(point, to: target)
        return target.point(inside: p, with: event)
    }
}
