//
//  HoldingsViewModel.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import Foundation

@MainActor
final class HoldingsViewModel: NSObject {
    
    // MARK: - Types
    
    enum State: Equatable {
        case idle
        case loading
        case error(String)
    }
    
    enum Segment: Int {
        case positions = 0
        case holdings  = 1
    }
    
    // MARK: - Outputs (observe via onChange)
    
    private(set) var state: State = .idle {
        didSet { onChange?(self) }
    }
    
    private(set) var summary: PortfolioSummary = .init(
        currentValue: 0,
        totalInvestment: 0,
        totalPNL: 0,
        todaysPNL: 0
    ) {
        didSet { onChange?(self) }
    }
    
    private(set) var items: [HoldingCellViewModel] = [] {
        didSet { onChange?(self) }
    }
    
    private(set) var selectedSegment: Segment = .holdings {
        didSet {
            applySegment()
            onChange?(self)
        }
    }
    
    /// Notify UI on any change (simple MVVM w/o Rx/Combine to keep deps low).
    var onChange: ((HoldingsViewModel) -> Void)?
    
    // MARK: - Dependencies
    
    private let repository: HoldingsRepositoryType
    
    // MARK: - Storage (source of truth)
    
    private var holdings: [Holding] = [] {
        didSet {
            recomputeSummary()
            applySegment()
        }
    }
    
    // MARK: - Init
    
    init(repository: HoldingsRepositoryType) {
        self.repository = repository
    }
    
    // MARK: - Public API
    
    /// Initial load (safe to call multiple times).
    func load() {
        Task { await refresh() }
    }
    
    /// Refresh from repository with offline fallback.
    func refresh() async {
        state = .loading
        do {
            let fresh = try await repository.fetch(remoteFirst: true)
            holdings = fresh
            state = .idle
        } catch {
            // Try cached fallback if available (only if repository is our concrete type).
            if let concrete = repository as? HoldingsRepository,
               let cached = try? concrete.store.load() {
                holdings = cached
                state = .idle
            } else {
                state = .error("Failed to load holdings. Pull to retry.")
            }
        }
    }
    
    /// Switch UI segment.
    func setSegment(_ seg: Segment) {
        selectedSegment = seg
    }
    
    // MARK: - Private helpers
    
    private func recomputeSummary() {
        summary = PortfolioSummary.compute(from: holdings)
    }
    
    /// Build the table items for the selected segment.
    /// For now: both POSITIONS and HOLDINGS render the same dataset with different cells.
    private func applySegment() {
        // If you later need segment-specific filtering/sorting, do it here.
        let sorted = holdings.sorted {
            $0.symbol.localizedCaseInsensitiveCompare($1.symbol) == .orderedAscending
        }
        items = sorted.map { HoldingCellViewModel(holding: $0) }
    }
    
    // MARK: - DEBUG test hooks
    
    #if DEBUG
    struct TestHooks {
        private let vm: HoldingsViewModel
        init(_ vm: HoldingsViewModel) { self.vm = vm }
        
        func fetch() async { await vm.refresh() }
        
        @MainActor func setSegment(_ s: Segment) { vm.setSegment(s) }
        
        @MainActor var state: State { vm.state }
        @MainActor var summary: PortfolioSummary { vm.summary }
        @MainActor var items: [HoldingCellViewModel] { vm.items }
        @MainActor var selected: Segment { vm.selectedSegment }
        
        @MainActor func inject(_ holdings: [Holding]) {
            vm.holdings = holdings
        }
    }
    
    var testHooks: TestHooks { TestHooks(self) }
    #endif
}
