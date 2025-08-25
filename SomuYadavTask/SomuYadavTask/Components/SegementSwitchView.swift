//
//  SegementSwitchView.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

protocol SegmentedSwitchViewDelegate: AnyObject {
    func segmentedSwitchView(_ view: SegmentedSwitchView, didSelect index: Int)
}

final class SegmentedSwitchView: UIView {
    weak var delegate: SegmentedSwitchViewDelegate?

    private let positionsButton = UIButton(type: .custom)
    private let holdingsButton  = UIButton(type: .custom)
    private let stack = UIStackView()
    private let underlineView = UIView()

    private var underlineCenterXToPositions: NSLayoutConstraint!
    private var underlineCenterXToHoldings: NSLayoutConstraint!
    private var underlineWidth: NSLayoutConstraint!

    private(set) var selectedIndex: Int = 1 // default HOLDINGS

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 44)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configure() {
        backgroundColor = .systemBackground

        positionsButton.setTitle("POSITIONS", for: .normal)
        holdingsButton.setTitle("HOLDINGS",  for: .normal)

        [positionsButton, holdingsButton].forEach { btn in
            btn.setTitleColor(.secondaryLabel, for: .normal)
            btn.setTitleColor(.label,           for: .selected)
            btn.titleLabel?.font = .boldSystemFont(ofSize: 13)
            btn.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
        }

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 20

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        // Soft edges (999) prevent temporary 0-size probe breaks; UI remains identical.
        let top      = stack.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        let bottom   = stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        let leading  = stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        let trailing = stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        [top, bottom, leading, trailing].forEach { $0.priority = .init(999) }

        // Encourage full-width expansion.
        stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // Keep visually centered (coexists with soft edges).
        let cx = stack.centerXAnchor.constraint(equalTo: centerXAnchor)
        let cy = stack.centerYAnchor.constraint(equalTo: centerYAnchor)

        NSLayoutConstraint.activate([top, bottom, leading, trailing, cx, cy])

        stack.addArrangedSubview(positionsButton)
        stack.addArrangedSubview(holdingsButton)

        // Underline
        underlineView.backgroundColor = .label
        underlineView.isUserInteractionEnabled = false
        addSubview(underlineView)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineWidth = underlineView.widthAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([
            underlineView.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
            underlineWidth,
            underlineView.heightAnchor.constraint(equalToConstant: 2)
        ])

        underlineCenterXToPositions = underlineView.centerXAnchor.constraint(equalTo: positionsButton.centerXAnchor)
        underlineCenterXToHoldings  = underlineView.centerXAnchor.constraint(equalTo: holdingsButton.centerXAnchor)

        setSelectedIndex(1, animated: false) // default HOLDINGS
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let selectedButton = (selectedIndex == 0) ? positionsButton : holdingsButton
        let titleWidth = selectedButton.titleLabel?.intrinsicContentSize.width ?? (bounds.width / 2.0 - 32)
        underlineWidth.constant = max(20, titleWidth + 8)
    }

    @objc private func onTap(_ sender: UIButton) {
        let index = (sender == positionsButton) ? 0 : 1
        setSelectedIndex(index, animated: true)
        delegate?.segmentedSwitchView(self, didSelect: index)
    }

    func setSelectedIndex(_ index: Int, animated: Bool) {
        selectedIndex = index
        positionsButton.isSelected = (index == 0)
        holdingsButton.isSelected  = (index == 1)

        // IMPORTANT: never keep both centerX constraints active at once.
        underlineCenterXToPositions.isActive = false
        underlineCenterXToHoldings.isActive  = false
        (index == 0 ? underlineCenterXToPositions : underlineCenterXToHoldings).isActive = true

        let updates = { self.layoutIfNeeded() }
        animated ? UIView.animate(withDuration: 0.2, animations: updates) : updates()
        setNeedsLayout()
    }
}

// MARK: - Test Hooks (DEBUG)
#if DEBUG
extension SegmentedSwitchView {
    var testHooks: TestHooks { TestHooks(target: self) }

    struct TestHooks {
        private let target: SegmentedSwitchView
        fileprivate init(target: SegmentedSwitchView) { self.target = target }

        var selectedIndex: Int { target.selectedIndex }

        func simulateTap(index: Int) {
            target.setSelectedIndex(index, animated: false)
            target.delegate?.segmentedSwitchView(target, didSelect: index)
        }
    }
}
#endif
