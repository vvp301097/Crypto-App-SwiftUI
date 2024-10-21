//
//  CryptoModel.swift
//  Crypto App
//
//  Created by Phat Vuong Vinh on 20/10/24.
//

import SwiftUI

struct CryptoModel: Identifiable, Codable {
    var id: String
    var symbol: String
    var name: String
    var image: String
    var currentPrice: Double
    var lastUpdated: String
    var priceChange: Double
    var last7DaysPrice: GraphModel
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case lastUpdated = "last_updated"
        case priceChange = "price_change_percentage_24h"
        case last7DaysPrice = "sparkline_in_7d"
    }
}


struct GraphModel: Codable {
    var price: [Double]
    
    enum CodingKeys: String, CodingKey {
        case price
    }
}


let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&sparkline=true&price_change_percentage=24h")
