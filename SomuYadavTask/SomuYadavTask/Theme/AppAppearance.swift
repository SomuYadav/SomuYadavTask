//
//  Untitled.swift
//  SomuYadavDemo
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

final class AppAppearance {
    
    /// Sets up the appearance of the app, including navigation bar styling and status bar style.
    static func setupAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor(hex: 0x000435)
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().tintColor = .white
        } else {
            UINavigationBar.appearance().barTintColor = UIColor(hex: 0x000435)
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
        }
        
        // Adjust spacing for stack views inside navigation bars.
        let stackViewAppearance = UIStackView.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        stackViewAppearance.spacing = -2
    }
}

// MARK: - UINavigationController Status Bar

extension UINavigationController {
    /// Overrides the preferred status bar style to light content (white text).
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - UIColor Convenience

extension UIColor {
    /// Convenience initializer for creating UIColor instances from hexadecimal values.
    ///
    /// - Parameter hex: The hexadecimal value representing the color.
    convenience init(hex: Int) {
        let components = (
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 08) & 0xff) / 255,
            blue: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: 1)
    }
}

// MARK: - UIButton Styling

extension UIButton {
    /// Underlines the button's text when it is selected.
    func underlineSelected() {
        guard let text = titleLabel?.text, isSelected else { return }
        guard let color = titleColor(for: .normal) ?? tintColor else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: text.count)
        
        attributedString.addAttribute(.underlineColor, value: color, range: range)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        setAttributedTitle(attributedString, for: .normal)
    }
}
