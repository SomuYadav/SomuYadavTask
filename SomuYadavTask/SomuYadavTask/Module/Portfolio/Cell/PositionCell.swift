//
//  Untitled.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

final class PositionCell: UITableViewCell {
    static let reuseIdentifier = "PositionCell"

    private let symbolLabel = UILabel()
    private let netQuantityLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configure() {
        symbolLabel.font = .preferredFont(forTextStyle: .headline)
        netQuantityLabel.font = .preferredFont(forTextStyle: .subheadline)
        netQuantityLabel.textColor = .secondaryLabel

        let row = UIStackView(arrangedSubviews: [symbolLabel, UIView(), netQuantityLabel])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8

        contentView.addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            row.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        selectionStyle = .none
    }

    func apply(viewModel: HoldingCellViewModel) {
        symbolLabel.text = viewModel.symbolText
        netQuantityLabel.attributedText = viewModel.netQuantityText
    }
}

#if DEBUG
extension PositionCell {
    var testHooks: (symbol: String?, netQty: NSAttributedString?) {
        (symbolLabel.text, netQuantityLabel.attributedText)
    }
}
#endif
