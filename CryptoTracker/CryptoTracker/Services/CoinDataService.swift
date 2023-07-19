// CoinDataService.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 17/07/23.

import Combine
import Foundation

class CoinDataService {
  @Published var allCoins: [CoinModel] = []

  var coinSubscription: AnyCancellable?

  init() {
    getCoins()
  }

  private func getCoins() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h&locale=en") else {
      return
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    coinSubscription = NetworkingManager.download(url: url)
      .decode(type: [CoinModel].self, decoder: decoder)
      .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
        self?.coinSubscription?.cancel()
      })
  }
}
