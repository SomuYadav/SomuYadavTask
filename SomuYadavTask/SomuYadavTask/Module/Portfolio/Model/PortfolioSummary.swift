//
//  PortfolioSummary.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import Foundation

struct PortfolioSummary: Equatable {
    let currentValue: Double
    let totalInvestment: Double
    let totalPNL: Double
    let todaysPNL: Double

    static func compute(from holdings: [Holding]) -> PortfolioSummary {
        var current = 0.0
        var invested = 0.0
        var today = 0.0
        for h in holdings {
            current += h.ltp * h.quantity
            invested += h.avgPrice * h.quantity
            today += (h.close - h.ltp) * h.quantity
        }
        return .init(currentValue: current,
                     totalInvestment: invested,
                     totalPNL: current - invested,
                     todaysPNL: today)
    }
}
