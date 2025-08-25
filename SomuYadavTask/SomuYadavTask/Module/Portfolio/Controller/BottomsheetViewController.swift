//
//  BottomsheetViewController.swift
//  SomuYadavDemo
//
//  Created by Somendra Yadav on 25/08/25.
//

import UIKit

class BottomSheetViewController: UIViewController {

  // MARK: - Views

  // Host view is set to passthrough in loadView()
  private(set) var containerView: UIView = {
    let view = UIView()
     view.backgroundColor = .secondarySystemBackground
     view.layer.cornerRadius = 12
     view.clipsToBounds = true
     view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    return view
  }()

  private lazy var pnlLabel: UILabel = {
    let pnlLabel = UILabel()
    pnlLabel.textColor = .darkGray
    pnlLabel.textAlignment = .left
    pnlLabel.font = .boldSystemFont(ofSize: 15)
    pnlLabel.text = "Profit & Loss"
    return pnlLabel
  }()

  private lazy var pnlLabelValue: UILabel = {
    let pnlLabelValue = UILabel()
    pnlLabelValue.textColor = .darkGray
    pnlLabelValue.textAlignment = .right
    pnlLabelValue.font = .boldSystemFont(ofSize: 15)
    return pnlLabelValue
  }()

  private lazy var arrowButton: UIButton = {
    let button = UIButton(type: .custom)
    button.tintColor = .darkGray
    button.contentHorizontalAlignment = .leading
    button.setImage(.init(systemName: "chevron.up"), for: .normal)
    button.setImage(.init(systemName: "chevron.down"), for: .selected)
    return button
  }()

  private lazy var pnlStackViewButton: UIStackView = {
    let pnlStackViewButton = UIStackView(arrangedSubviews: [pnlLabel, arrowButton])
    pnlStackViewButton.axis = .horizontal
    pnlStackViewButton.alignment = .leading
    pnlStackViewButton.distribution = .fillEqually
    return pnlStackViewButton
  }()

  private lazy var pnlStackView: UIStackView = {
    let pnlStackView = UIStackView(arrangedSubviews: [pnlStackViewButton, pnlLabelValue])
    pnlStackView.axis = .horizontal
    pnlStackView.distribution = .fillEqually
    return pnlStackView
  }()

  private lazy var todayPNLLabel: UILabel = {
    let todayPNLLabel = UILabel()
    todayPNLLabel.textColor = .darkGray
    todayPNLLabel.textAlignment = .left
    todayPNLLabel.font = .boldSystemFont(ofSize: 15)
    todayPNLLabel.text = "Today's Profit & Loss"
    return todayPNLLabel
  }()

  private lazy var todayPNLLabelValue: UILabel = {
    let todayPNLLabelValue = UILabel()
    todayPNLLabelValue.textColor = .darkGray
    todayPNLLabelValue.textAlignment = .right
    todayPNLLabelValue.font = .boldSystemFont(ofSize: 15)
    return todayPNLLabelValue
  }()

  private lazy var todayPNLStackView: UIStackView = {
    let todayPNLStackView = UIStackView(arrangedSubviews: [todayPNLLabel, todayPNLLabelValue])
    todayPNLStackView.axis = .horizontal
    todayPNLStackView.distribution = .fillProportionally
    return todayPNLStackView
  }()

  private lazy var totalInvestmentLabel: UILabel = {
    let totalInvestmentLabel = UILabel()
    totalInvestmentLabel.textColor = .darkGray
    totalInvestmentLabel.textAlignment = .left
    totalInvestmentLabel.font = .boldSystemFont(ofSize: 15)
    totalInvestmentLabel.text = "Total Investment"
    return totalInvestmentLabel
  }()

  private lazy var totalInvestmentLabelValue: UILabel = {
    let totalInvestmentLabelValue = UILabel()
    totalInvestmentLabelValue.textColor = .darkGray
    totalInvestmentLabelValue.textAlignment = .right
    totalInvestmentLabelValue.font = .boldSystemFont(ofSize: 15)
    return totalInvestmentLabelValue
  }()

  private lazy var totalInvestmentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [totalInvestmentLabel, totalInvestmentLabelValue])
    stackView.axis = .horizontal
    stackView.distribution = .fill
    return stackView
  }()

  private lazy var currentValueLabel: UILabel = {
    let label = UILabel()
    label.textColor = .darkGray
    label.textAlignment = .left
    label.font = .boldSystemFont(ofSize: 15)
    label.text = "Current Value"
    return label
  }()

  private lazy var currentValueLabelValue: UILabel = {
    let label = UILabel()
    label.textColor = .darkGray
    label.textAlignment = .right
    label.font = .boldSystemFont(ofSize: 15)
    return label
  }()

  private lazy var currentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [currentValueLabel, currentValueLabelValue])
    stackView.axis = .horizontal
    stackView.distribution = .fill
    return stackView
  }()

  private let divider: UIView = {
    let divider = UIView()
    divider.backgroundColor = .darkGray
    return divider
  }()

  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      currentStackView,
      totalInvestmentStackView,
      todayPNLStackView,
      divider,
      pnlStackView
    ])
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.distribution = .fill
    return stackView
  }()

  // MARK: - Sizing / Constraints

  var defaultHeight: CGFloat = 45
  let dismissibleHeight: CGFloat = 10
  var currentContainerHeight: CGFloat = 190
  var maximumContainerHeight: CGFloat {
    min(UIScreen.main.bounds.height * 0.40, 190)
  }

  private var containerViewHeightConstraint: NSLayoutConstraint?
  private var containerViewBottomConstraint: NSLayoutConstraint?

  // MARK: - Lifecycle

  override func loadView() {
    // Use passthrough host so touches outside container go to underlying views (table/tabs)
    let bottomSheetPassthroughView = BottomSheetPassthroughView()
    bottomSheetPassthroughView.translatesAutoresizingMaskIntoConstraints = false
    view = bottomSheetPassthroughView
    view.backgroundColor = .clear
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    setupPanGesture()
    arrowButton.addTarget(self, action: #selector(handleCloseAction), for: .touchUpInside)
    animatePresentContainer()
    arrowButton.isSelected = true
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    (view as? BottomSheetPassthroughView)?.hitTarget = containerView
  }

  // MARK: - Public API

  func updateLabels(summary: PortfolioSummary) {
    applyPnlValues(
      todayPNL: summary.todaysPNL,
      totalPNL: summary.totalPNL,
      totalInvestment: summary.totalInvestment,
      currentValue: summary.currentValue
    )
  }

  func updateLabels(todayPNL: Double, totalPNL: Double, totalInvestment: Double, currentValue: Double) {
    applyPnlValues(
      todayPNL: todayPNL,
      totalPNL: totalPNL,
      totalInvestment: totalInvestment,
      currentValue: currentValue
    )
  }
}

// MARK: - Setup
private extension BottomSheetViewController {
  func setupView() {
    // collapsed view shows only header row
    showAllStack(isShowAll: true)
  }

  func setupConstraints() {
    view.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false

    containerView.addSubview(contentStackView)
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    divider.translatesAutoresizingMaskIntoConstraints = false

    let bottom = contentStackView.bottomAnchor.constraint(
        lessThanOrEqualTo: containerView.bottomAnchor, constant: -12
    )
    bottom.priority = .defaultHigh
      
    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

      contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
      contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
      bottom,
      divider.heightAnchor.constraint(equalToConstant: 1)
    ])
      
    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
    containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)

    containerViewHeightConstraint?.isActive = true
    containerViewBottomConstraint?.isActive = true
  }

  func setupPanGesture() {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
    pan.delaysTouchesBegan = false
    pan.delaysTouchesEnded = false
    containerView.addGestureRecognizer(pan)
  }

  func applyPnlValues(todayPNL: Double, totalPNL: Double, totalInvestment: Double, currentValue: Double) {
    todayPNLLabelValue.text = CurrencyFormatter.string(todayPNL)
    todayPNLLabelValue.textColor = todayPNL < 0 ? .systemRed : .label

    pnlLabelValue.text = CurrencyFormatter.string(totalPNL)
    pnlLabelValue.textColor = totalPNL < 0 ? .systemRed : .label

    totalInvestmentLabelValue.text = CurrencyFormatter.string(totalInvestment)
    currentValueLabelValue.text = CurrencyFormatter.string(currentValue)
  }
}

// MARK: - Animations / Pan
extension BottomSheetViewController {
  func animatePresentContainer() {
      self.showAllStack(isShowAll: true)
      self.containerViewBottomConstraint?.constant = 0
      self.containerViewHeightConstraint?.constant = self.defaultHeight
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }

  func showAllStack(isShowAll: Bool) {
    currentStackView.isHidden = isShowAll
    todayPNLStackView.isHidden = isShowAll
    totalInvestmentStackView.isHidden = isShowAll
    divider.isHidden = isShowAll
  }

  func animateDismissView() {
    let expanded = self.arrowButton.isSelected
    self.showAllStack(isShowAll: !expanded)
    self.containerViewHeightConstraint?.constant = expanded ? max(self.currentContainerHeight, 190) : self.defaultHeight
    UIView.animate(withDuration: 0.25) {
      self.arrowButton.isSelected.toggle()
      self.view.layoutIfNeeded()
    }
  }

  func animateContainerHeight(_ height: CGFloat) {
    self.containerViewHeightConstraint?.constant = height
    self.currentContainerHeight = height
    UIView.animate(withDuration: 0.25) {
      self.view.layoutIfNeeded()
    }
  }

  @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    let isDraggingDown = translation.y > 0
    let newHeight = currentContainerHeight - translation.y

    switch gesture.state {
    case .changed:
      if newHeight < maximumContainerHeight, newHeight > dismissibleHeight {
        containerViewHeightConstraint?.constant = newHeight
        view.layoutIfNeeded()
      }
    case .ended:
      if newHeight < dismissibleHeight {
        arrowButton.isSelected = true
        showAllStack(isShowAll: true)
        animateContainerHeight(defaultHeight)
      } else if newHeight < defaultHeight {
        animateContainerHeight(defaultHeight)
      } else if newHeight < maximumContainerHeight && isDraggingDown {
        animateContainerHeight(defaultHeight)
        arrowButton.isSelected = false
        showAllStack(isShowAll: true)
      } else if newHeight > defaultHeight && !isDraggingDown {
        let target = min(maximumContainerHeight, max(newHeight, 190))
        animateContainerHeight(target)
        arrowButton.isSelected = true
        showAllStack(isShowAll: false)
      }
      currentContainerHeight = containerViewHeightConstraint?.constant ?? defaultHeight
    default:
      break
    }
  }

  @objc func handleCloseAction() {
    animateDismissView()
  }
}

#if DEBUG
extension BottomSheetViewController {
  var testHooks: TestHooks { TestHooks(target: self) }
  struct TestHooks {
    private let target: BottomSheetViewController
    fileprivate init(target: BottomSheetViewController) { self.target = target }
    var containerView: UIView { target.containerView }
    func simulateToggle() { target.handleCloseAction() }
    func apply(summary: PortfolioSummary) { target.updateLabels(summary: summary) }
  }
}
#endif
