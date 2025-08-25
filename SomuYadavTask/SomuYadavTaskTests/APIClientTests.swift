//
//  APIClientTests.swift
//  SomuYadavTask
//
//  Created by Somendra Yadav on 25/08/25.
//

import XCTest
@testable import SomuYadavTask

final class APIClientTests: XCTestCase {
    final class StubProtocol: URLProtocol {
        static var responder: (() -> (Int, Data))?
        override class func canInit(with request: URLRequest) -> Bool { true }
        override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
        override func startLoading() {
            guard let (code, data) = Self.responder?() else { return }
            let resp = HTTPURLResponse(url: request.url!, statusCode: code, httpVersion: nil, headerFields: nil)!
            client?.urlProtocol(self, didReceive: resp, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        override func stopLoading() {}
    }

    func test_fetchHoldings_parsesPayload() async throws {
        let cfg = URLSessionConfiguration.ephemeral
        cfg.protocolClasses = [StubProtocol.self]
        let session = URLSession(configuration: cfg)
        let api = APIClient(session: session)

        let json = """
        { "data": { "userHolding": [
            { "symbol":"A", "quantity":1, "ltp":2, "avgPrice":1.5, "close":1.8 }
        ]}}
        """.data(using: .utf8)!
        StubProtocol.responder = { (200, json) }

        let got = try await api.fetchHoldings()
        XCTAssertEqual(got.count, 1)
        XCTAssertEqual(got.first?.symbol, "A")
    }

    func test_fetchHoldings_badStatus_throws() async {
        let cfg = URLSessionConfiguration.ephemeral
        cfg.protocolClasses = [StubProtocol.self]
        let session = URLSession(configuration: cfg)
        let api = APIClient(session: session)

        StubProtocol.responder = { (500, Data()) }

        do {
            _ = try await api.fetchHoldings()
            XCTFail("Expected error but no error thrown")
        } catch {
            XCTAssertTrue(error is URLError || error is DecodingError)
        }
    }
}
