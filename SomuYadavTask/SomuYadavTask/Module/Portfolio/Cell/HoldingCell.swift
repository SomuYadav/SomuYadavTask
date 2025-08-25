//
//  HoldingCell.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

class HoldingCell: UITableViewCell {
  static let reuseIdentifier = "HoldingCell"
    
  var stockLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = .boldSystemFont(ofSize: 16)
    return label
  }()
  
  var netQtyLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = .boldSystemFont(ofSize: 12)
    return label
  }()
  
  var ltpLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = .boldSystemFont(ofSize: 12)
    return label
  }()
  
  var profitAndLossLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = .boldSystemFont(ofSize: 12)
    return label
  }()
  
  var tagLabel = TagLabelView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setPortfolioConstraints()
    tagLabel.setText("T1 Holding")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HoldingCell {
  func setPortfolioConstraints() {
    contentView.addSubview(stockLabel)
    stockLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
    ])
    
    // Tag Label
    contentView.addSubview(tagLabel)
    tagLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tagLabel.centerYAnchor.constraint(equalTo: stockLabel.centerYAnchor),
      tagLabel.leadingAnchor.constraint(equalTo: stockLabel.trailingAnchor, constant: 10)
    ])
    
    // Net Qty Label
    contentView.addSubview(netQtyLabel)
    netQtyLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      netQtyLabel.topAnchor.constraint(equalTo: stockLabel.bottomAnchor, constant: 20),
      netQtyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
    ])
    
    // LTP Label
    contentView.addSubview(ltpLabel)
    ltpLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      ltpLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
    
    // P&L Label
    contentView.addSubview(profitAndLossLabel)
    profitAndLossLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      profitAndLossLabel.topAnchor.constraint(equalTo: ltpLabel.bottomAnchor, constant: 20),
      profitAndLossLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      profitAndLossLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
    ])
  }
  
    func apply(viewModel: HoldingCellViewModel) {
        stockLabel.text = viewModel.symbolText
        netQtyLabel.attributedText = viewModel.netQuantityText
        ltpLabel.attributedText = viewModel.ltpText
        profitAndLossLabel.attributedText = viewModel.pnlText
    }
}
