//
//  Untitled.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import Foundation

enum CurrencyFormatter {
    private static var cached: [String: NumberFormatter] = [:]

    private static func formatter(for locale: Locale) -> NumberFormatter {
        let key = locale.identifier
        if let f = cached[key] { return f }
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.maximumFractionDigits = 2
        nf.locale = locale
        cached[key] = nf
        return nf
    }

    static func string(_ value: Double, locale: Locale = Locale(identifier: "en_IN")) -> String {
        let nf = formatter(for: locale)
        return nf.string(from: NSNumber(value: value)) ?? String(format: "₹%.2f", value)
    }
}
