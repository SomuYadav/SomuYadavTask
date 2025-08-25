import Foundation

struct Holding: Codable, Hashable {
    let symbol: String
    let quantity: Double
    // FMI: Last Trade Price
    let ltp: Double
    let avgPrice: Double
    let close: Double

    private enum CodingKeys: String, CodingKey {
        case symbol, quantity, ltp, avgPrice, close
    }

    private enum AltDecodingKeys: String, CodingKey {
        case symbol, quantity, ltp, avgPrice, close
        case qty
        case lastTradedPrice
        case averagePrice
        case prevClose
        case avg_price
    }

    init(symbol: String, quantity: Double, ltp: Double, avgPrice: Double, close: Double) {
        self.symbol = symbol
        self.quantity = quantity
        self.ltp = ltp
        self.avgPrice = avgPrice
        self.close = close
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AltDecodingKeys.self)

        self.symbol = try c.decode(String.self, forKey: .symbol)

        // quantity
        if let v = try? c.decode(Double.self, forKey: .quantity) {
            self.quantity = v
        } else if let v = try? c.decode(Double.self, forKey: .qty) {
            self.quantity = v
        } else if let s = try? c.decode(String.self, forKey: .quantity), let v = Double(s) {
            self.quantity = v
        } else if let s = try? c.decode(String.self, forKey: .qty), let v = Double(s) {
            self.quantity = v
        } else {
            self.quantity = 0
        }

        // ltp
        if let v = try? c.decode(Double.self, forKey: .ltp) {
            self.ltp = v
        } else if let v = try? c.decode(Double.self, forKey: .lastTradedPrice) {
            self.ltp = v
        } else if let s = try? c.decode(String.self, forKey: .ltp), let v = Double(s) {
            self.ltp = v
        } else {
            self.ltp = 0
        }

        // avgPrice
        if let v = try? c.decode(Double.self, forKey: .avgPrice) {
            self.avgPrice = v
        } else if let v = try? c.decode(Double.self, forKey: .averagePrice) {
            self.avgPrice = v
        } else if let s = try? c.decode(String.self, forKey: .avg_price), let v = Double(s) {
            self.avgPrice = v
        } else {
            self.avgPrice = 0
        }

        // close
        if let v = try? c.decode(Double.self, forKey: .close) {
            self.close = v
        } else if let v = try? c.decode(Double.self, forKey: .prevClose) {
            self.close = v
        } else {
            self.close = 0
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(symbol, forKey: .symbol)
        try c.encode(quantity, forKey: .quantity)
        try c.encode(ltp, forKey: .ltp)
        try c.encode(avgPrice, forKey: .avgPrice)
        try c.encode(close, forKey: .close)
    }
}
