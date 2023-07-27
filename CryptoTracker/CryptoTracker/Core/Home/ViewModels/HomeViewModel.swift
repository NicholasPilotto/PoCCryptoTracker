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
  @Published var isLoading: Bool = false

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

  private func mapAllCoinsToPortfolioCoins(coinModels: [CoinModel], portfolioEnities: [PortfolioEntity]) -> [CoinModel] {
    coinModels.compactMap { coin -> CoinModel? in
      guard let entity = portfolioEnities.first(where: { $0.coinID == coin.id }) else {
        return nil
      }

      var returnedCoin = coin
      returnedCoin.updateHoldings(amount: entity.amount)
      return returnedCoin
    }
  }

  private func mapGlobalMarketData(markedDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
    var stats: [StatisticModel] = []

    guard let data = markedDataModel else {
      return stats
    }

    let portfolioValue =
      portfolioCoins
        .map { $0.currentHoldingsValue }
        .reduce(0, +)

    let previousValue =
      portfolioCoins.map { coin -> Double in
        let currentValue = coin.currentHoldingsValue
        let percentageChange = (coin.priceChangePercentage24H ?? 0) / 100
        return currentValue / (1 + percentageChange)
      }
      .reduce(0, +)

    let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100

    stats.append(contentsOf: [
      StatisticModel(title: "Market cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd),
      StatisticModel(title: "Volume", value: data.volume),
      StatisticModel(title: "BTC dominance", value: data.btcDominance),
      StatisticModel(title: "Portfolio value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange),
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

    // updates portfolio
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map(mapAllCoinsToPortfolioCoins)
      .sink { [weak self] returnedCoins in
        self?.portfolioCoins = returnedCoins
      }
      .store(in: &cancellables)

    // updates market data
    markedDataService.$marketData
      .combineLatest($portfolioCoins)
      .map(mapGlobalMarketData)
      .sink { [weak self] marketDataReturned in
        self?.statistics = marketDataReturned
        self?.isLoading = false
      }
      .store(in: &cancellables)
  }

  func updatePortfolio(coin: CoinModel, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }

  func reloadData() {
    isLoading = true
    coinDataService.getCoins()
    markedDataService.getData()
    HapticManager.notification(type: .success)
  }
}
