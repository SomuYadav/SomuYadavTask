//
//  HoldingStore.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import Foundation

protocol HoldingsStoreType { func save(_ holdings: [Holding]) throws; func load() throws -> [Holding] }

final class HoldingsStore: HoldingsStoreType {
    private let fileURL: URL
    init(filename: String = "holdings_cache.json") {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.fileURL = dir.appendingPathComponent(filename)
    }
    func save(_ holdings: [Holding]) throws {
        let data = try JSONEncoder().encode(holdings)
        try data.write(to: fileURL, options: .atomic)
    }
    func load() throws -> [Holding] {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([Holding].self, from: data)
    }
}
