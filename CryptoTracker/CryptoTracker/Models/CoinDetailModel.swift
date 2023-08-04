//
//  CoinDetailModel.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 04/08/23.
//

import Foundation

struct CoinDetailModel: Codable {
  let id: String?
  let symbol: String?
  let name: String?
  let blockTimeInMinutes: Int?
  let hashingAlgorithm: String?
  let categories: [String]?
  let description: Description?
  let links: Links?
}

struct Description: Codable {
  // swiftlint:disable:next identifier_name
  let en: String?
}

struct Links: Codable {
  let homepage: [String]?
  let subredditURL: String?
}
