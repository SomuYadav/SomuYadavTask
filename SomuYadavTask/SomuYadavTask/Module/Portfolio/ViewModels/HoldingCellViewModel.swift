//
//  View.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

final class HoldingCellViewModel: Hashable {
    let holding: Holding
    init(holding: Holding) { self.holding = holding }

    var symbolText: String {
        holding.symbol
    }
    
    var netQuantityText: NSAttributedString {
        .getAttributedString(leftString: "Net Qty",
                             rightString: "\(Int(holding.quantity))")
        
    }
    var ltpText: NSAttributedString {
        return .getAttributedString(leftString: "LTP ",
                                    rightString: "\(CurrencyFormatter.string(holding.ltp))"
        )
    }
    var pnlValue: Double { (holding.ltp - holding.avgPrice) * holding.quantity }
    var pnlText: NSAttributedString {
        let pnl = "\(CurrencyFormatter.string(pnlValue))"
        let color: UIColor = isGain ? .systemGreen : .systemRed
        return .getAttributedString(leftString: "P&L ",
                                    rightString: "\(pnl)",
                                    rightStringColor: color)
    }
    var isGain: Bool { pnlValue >= 0 }

    static func == (lhs: HoldingCellViewModel, rhs: HoldingCellViewModel) -> Bool { lhs.holding == rhs.holding }
    func hash(into hasher: inout Hasher) { hasher.combine(holding) }
}
