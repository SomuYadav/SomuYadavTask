//
//  Untitled.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import Foundation

protocol HoldingsRepositoryType { func fetch(remoteFirst: Bool) async throws -> [Holding] }

final class HoldingsRepository: HoldingsRepositoryType {
    private let apiClient: APIClientType
    let store: HoldingsStoreType

    init(apiClient: APIClientType = APIClient(), store: HoldingsStoreType = HoldingsStore()) {
        self.apiClient = apiClient
        self.store = store
    }

    func fetch(remoteFirst: Bool = true) async throws -> [Holding] {
        if remoteFirst {
            do {
                let fresh = try await apiClient.fetchHoldings()
                try? store.save(fresh)
                return fresh
            } catch {
                if let cached = try? store.load() { return cached }
                throw error
            }
        } else {
            if let cached = try? store.load() { return cached }
            let fresh = try await apiClient.fetchHoldings()
            try? store.save(fresh)
            return fresh
        }
    }
}
