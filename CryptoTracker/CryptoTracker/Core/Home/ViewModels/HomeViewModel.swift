// HomeViewModel.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 17/07/23.

import Combine
import Foundation

class HomeViewModel: ObservableObject {
  
  @Published var statistics: [StatisticModel] = [
    StatisticModel(title: "Title", value: "Value", percentageChange: 1),
    StatisticModel(title: "Title", value: "Value"),
    StatisticModel(title: "Title", value: "Value"),
    StatisticModel(title: "Title", value: "Value", percentageChange: -7 ),
  ]
  
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  @Published var searchedText: String = ""
  
  private let dataService = CoinDataService()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
    guard !text.isEmpty else {
      return coins
    }
    
    let lowercaseText = text.lowercased()
    return coins.filter { (coin) in
      return coin.name.lowercased().contains(lowercaseText) ||
      coin.symbol.lowercased().contains(lowercaseText) ||
      coin.id.lowercased().contains(lowercaseText)
    }
  }
  
  func addSubscribers() {    
    $searchedText
      .combineLatest(dataService.$allCoins)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterCoins)
      .sink { [weak self] (returnedCoins) in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
  }
}
