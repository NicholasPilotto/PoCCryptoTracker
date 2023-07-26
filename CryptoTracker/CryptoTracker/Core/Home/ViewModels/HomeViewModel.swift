// HomeViewModel.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 17/07/23.

import Combine
import Foundation

class HomeViewModel: ObservableObject {
  @Published var statistics: [StatisticModel] = []

  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  @Published var searchedText: String = ""

  // data service
  private let coinDataService = CoinDataService()
  private let markedDataService = MarketDataService()
  private let portfolioDataService = PortfolioDataService()
  
  private var cancellables = Set<AnyCancellable>()

  init() {
    addSubscribers()
  }

  private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
    guard !text.isEmpty else {
      return coins
    }

    let lowercaseText = text.lowercased()
    return coins.filter { coin in
      coin.name.lowercased().contains(lowercaseText) ||
        coin.symbol.lowercased().contains(lowercaseText) ||
        coin.id.lowercased().contains(lowercaseText)
    }
  }

  private func mapGlobalMarketData(markedDataModel: MarketDataModel?) -> [StatisticModel] {
    var stats: [StatisticModel] = []
    guard let data = markedDataModel else {
      return stats
    }

    stats.append(contentsOf: [
      StatisticModel(title: "Market cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd),
      StatisticModel(title: "Volume", value: data.volume),
      StatisticModel(title: "BTC dominance", value: data.btcDominance),
      StatisticModel(title: "Portfolio value", value: "$0.00", percentageChange: 0),
    ])

    return stats
  }

  func addSubscribers() {
    // update coins data
    $searchedText
      .combineLatest(coinDataService.$allCoins)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)

    // updates market data
    markedDataService.$marketData
      .map(mapGlobalMarketData)
      .sink { [weak self] marketDataReturned in
        self?.statistics = marketDataReturned
      }
      .store(in: &cancellables)
    
    // updates portfolio
    $allCoins
      .combineLatest(self.portfolioDataService.$savedEntities)
      .map { (coinModels, portfolioEnities) -> [CoinModel] in
        coinModels.compactMap { (coin) -> CoinModel? in
          guard let entity = portfolioEnities.first(where: { $0.coinID == coin.id }) else {
            return nil
          }
          
          var returnedCoin = coin
          returnedCoin.updateHoldings(amount: entity.amount)
          return returnedCoin
        }
      }
      .sink { [weak self] (returnedCoins) in
        self?.portfolioCoins = returnedCoins
      }
      .store(in: &cancellables)
  }
  
  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }
}
