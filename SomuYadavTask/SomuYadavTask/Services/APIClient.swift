//
//  APIClient.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import Foundation

protocol APIClientType { func fetchHoldings() async throws -> [Holding] }

final class APIClient: APIClientType {
    static let endpoint = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/")!
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }

    struct Payload: Decodable {
        struct DataContainer: Decodable { let userHolding: [Holding] }
        let data: DataContainer
    }

    func fetchHoldings() async throws -> [Holding] {
        let (data, response) = try await session.data(from: Self.endpoint)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        let payload = try JSONDecoder().decode(Payload.self, from: data)
        return payload.data.userHolding
    }
}
