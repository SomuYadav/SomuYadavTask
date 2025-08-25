//
//  Untitled.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//
import Foundation

struct HoldingsCurrencyFormatter {
    static let string: (Double) -> String = { value in
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
