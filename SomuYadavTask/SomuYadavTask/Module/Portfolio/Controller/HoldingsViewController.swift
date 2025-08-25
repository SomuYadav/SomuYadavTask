//
//  HoldigViewController.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

// HoldingsViewController.swift
import UIKit

final class HoldingsViewController: UIViewController {
    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var refreshControl: UIRefreshControl = {
      let refreshControl = UIRefreshControl()
      refreshControl.tintColor = .lightGray
      return refreshControl
    }()
    
    private let segmentedView = SegmentedSwitchView()

    // MARK: - VM
    private let viewModel: HoldingsViewModel

    // MARK: - Bottom Sheet (child VC)
    private var bottomSheetVC: BottomSheetViewController?

    // MARK: - Init
    init(viewModel: HoldingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Portfolio"
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureSegmented()
        configureTable()
        configureBottomSheet()
        bindViewModel()

        viewModel.setSegment(.holdings)
        segmentedView.setSelectedIndex(1, animated: true)

        viewModel.load()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure table scrolls above the sheet; give generous space for expanded height
        let bottomInset = view.safeAreaInsets.bottom + 220
        if tableView.contentInset.bottom != bottomInset {
            tableView.contentInset.bottom = bottomInset
            tableView.verticalScrollIndicatorInsets.bottom = bottomInset
        }
    }

    // MARK: - Setup
    private func configureSegmented() {
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configureTable() {
        tableView.register(PositionCell.self, forCellReuseIdentifier: PositionCell.reuseIdentifier)
        tableView.register(HoldingCell.self, forCellReuseIdentifier: HoldingCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureBottomSheet() {
        // Embed your bottom sheet VC so it controls its own pan/height internally
        let vc = BottomSheetViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vc.view.topAnchor.constraint(equalTo: view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        vc.didMove(toParent: self)
        bottomSheetVC = vc
    }

    // MARK: - Actions
    @objc private func onPullToRefresh() { Task { await viewModel.refresh() } }

    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.onChange = { [weak self] vm in
            guard let self = self else { return }

            switch vm.state {
            case .loading:
                if !self.refreshControl.isRefreshing { self.refreshControl.beginRefreshing() }
            case .idle, .error:
                if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
            }

            // Mirror VM -> segmented control
            switch vm.selectedSegment {
            case .positions: self.segmentedView.setSelectedIndex(0, animated: true)
            case .holdings:  self.segmentedView.setSelectedIndex(1, animated: true)
            }

            // Update bottom sheet labels using the summary from VM
            self.bottomSheetVC?.updateLabels(summary: vm.summary)

            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableView
extension HoldingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = viewModel.items[indexPath.row]
        switch viewModel.selectedSegment {
        case .positions:
            let cell = tableView.dequeueReusableCell(withIdentifier: PositionCell.reuseIdentifier, for: indexPath) as! PositionCell
            cell.apply(viewModel: vm)
            return cell
        case .holdings:
            let cell = tableView.dequeueReusableCell(withIdentifier: HoldingCell.reuseIdentifier, for: indexPath) as! HoldingCell
            cell.apply(viewModel: vm)
            return cell
        }
    }
}

// MARK: - SegmentedSwitchViewDelegate
extension HoldingsViewController: SegmentedSwitchViewDelegate {
    func segmentedSwitchView(_ view: SegmentedSwitchView, didSelect index: Int) {
        viewModel.setSegment(index == 0 ? .positions : .holdings)
        tableView.reloadData()
        tableView.setContentOffset(.zero, animated: true)
    }
}

#if DEBUG
extension HoldingsViewController {
    var testHooks: TestHooks { TestHooks(target: self) }

    struct TestHooks {
        private let target: HoldingsViewController
        fileprivate init(target: HoldingsViewController) { self.target = target }

        var tableView: UITableView { target.tableView }
        var segmentedView: SegmentedSwitchView { target.segmentedView }
        var bottomSheet: BottomSheetViewController? { target.bottomSheetVC }

        func simulateSegmentTap(index: Int) {
            target.segmentedSwitchView(target.segmentedView, didSelect: index)
        }
    }
}
#endif
