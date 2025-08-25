//
//  Untitled.swift
//  SomuYadavDemo
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

extension NSAttributedString {
  static func getAttributedString(leftString: String, rightString: String, rightStringColor: UIColor = .systemGreen) -> NSAttributedString {
    
    let attributedString = NSMutableAttributedString(string: "\(leftString): \(rightString)")
    
    // Set color for left string
    let leftStringRange = NSRange(location: 0, length: leftString.count)
    attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: leftStringRange)
    
    // Set color for right string
    let rightStringRange = NSRange(location: leftString.count + 2, length: rightString.count)
    attributedString.addAttribute(.foregroundColor, value: rightStringColor, range: rightStringRange)
    
    return attributedString
  }
}
