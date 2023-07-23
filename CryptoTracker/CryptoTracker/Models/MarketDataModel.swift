// MarketDataModel.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 23/07/23.

import Foundation

/// Model data incoming form
/// URL: https://api.coingecko.com/api/v3/global
struct GlobalData: Codable {
  let data: MarketDataModel?
}

/// Model market data
struct MarketDataModel: Codable {
  let totalMarketCap: [String: Double]
  let totalVolume: [String: Double]
  let marketCapPercentage: [String: Double]
  let marketCapChangePercentage24HUsd: Double

  var marketCap: String {
    if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
      return "$" + item.value.formattedWithAbbreviations()
    }

    return ""
  }

  var volume: String {
    if let item = totalVolume.first(where: { $0.key == "usd" }) {
      return "$" + item.value.formattedWithAbbreviations()
    }

    return ""
  }

  var btcDominance: String {
    if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
      return item.value.asPercentString()
    }

    return ""
  }
}
