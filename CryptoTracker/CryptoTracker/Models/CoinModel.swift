//
//  CoinModel.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 15/07/23.
//

import Foundation

/**
 coingecko.com API info
 
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&locale=en&precision=18
 */

struct CoinModel: Identifiable, Codable {
  let id: String
  let symbol: String
  let name: String
  let image: String?
  let currentPrice: Double
  let marketCap: Double?
  let marketCapRank: Double?
  let fullyDilutedValuation: Double?
  let totalVolume: Double?
  let high24H, low24H: Double?
  let priceChange24H: Double?
  let priceChangePercentage24H: Double?
  let marketCapChange24H: Double?
  let marketCapChangePercentage24H: Double?
  let circulatingSupply: Double?
  let totalSupply: Double?
  let maxSupply: Double?
  let ath: Double?
  let athChangePercentage: Double?
  let athDate: String?
  let atl: Double?
  let atlChangePercentage: Double?
  let atlDate: String?
  let lastUpdated: String?
  let sparklineIn7D: SparklineIn7D?
  let priceChangePercentage24HInCurrency: Double?
  var currentHoldings: Double?
  
  mutating func updateHoldings(amount: Double) {
    self.currentHoldings = amount
  }
  
  var currentHoldingsValue: Double {
    return currentPrice * (currentHoldings ?? 0)
  }
  
  var rank: Int {
    return Int(marketCapRank ?? 0)
  }
}

struct SparklineIn7D: Codable {
  let price: [Double]?
}

