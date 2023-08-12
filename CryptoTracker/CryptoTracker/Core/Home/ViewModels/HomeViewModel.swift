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
  @Published var isLoading = false
  @Published var sortOption: SortOption = .holdings

  // data service
  private let coinDataService = CoinDataService()
  private let markedDataService = MarketDataService()
  private let portfolioDataService = PortfolioDataService()

  private var cancellables = Set<AnyCancellable>()
  
  enum SortOption {
    case rank
    case rankReversed
    case holdings
    case holdingsReversed
    case price
    case priceReversed
  }

  init() {
    addSubscribers()
  }
  
  private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
    var updatedCoins = filterCoins(text: text, coins: coins)
    sortCoins(sort: sort, coins: &updatedCoins)
    return updatedCoins
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
  
  private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
    switch sort {
      case .rank, .holdings:
        coins.sort(by: { $0.rank < $1.rank })
      case .rankReversed, .holdingsReversed:
        coins.sort(by: { $0.rank >= $1.rank })
      case .price:
        coins.sort(by: { $0.currentPrice < $1.currentPrice })
      case .priceReversed:
        coins.sort(by: { $0.currentPrice >= $1.currentPrice })
    }
  }
  
  private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
    switch sortOption {
      case .holdings:
        return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
      case .holdingsReversed:
        return coins.sorted(by: { $0.currentHoldingsValue <= $1.currentHoldingsValue })
        
      default:
        return coins
    }
  }

  private func mapAllCoinsToPortfolioCoins(
    coinModels: [CoinModel], portfolioEnities: [PortfolioEntity]
  ) -> [CoinModel] {
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

    let percentageChange = ((portfolioValue - previousValue) / previousValue)

    stats.append(contentsOf: [
      StatisticModel(
        title: "Market cap",
        value: data.marketCap,
        percentageChange: data.marketCapChangePercentage24HUsd
      ),
      StatisticModel(
        title: "Volume",
        value: data.volume
      ),
      StatisticModel(
        title: "BTC dominance",
        value: data.btcDominance
      ),
      StatisticModel(
        title: "Portfolio value",
        value: portfolioValue.asCurrencyWith2Decimals(),
        percentageChange: percentageChange
      )
    ])

    return stats
  }

  public func addSubscribers() {
    // update coins data
    $searchedText
      .combineLatest(coinDataService.$allCoins, $sortOption)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterAndSortCoins)
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)

    // updates portfolio
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map(mapAllCoinsToPortfolioCoins)
      .sink { [weak self] returnedCoins in
        guard let self = self else {
          return
        }
        self.portfolioCoins = returnedCoins // self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
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
