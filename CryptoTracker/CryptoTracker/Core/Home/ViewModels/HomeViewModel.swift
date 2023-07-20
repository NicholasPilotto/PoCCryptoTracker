// HomeViewModel.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 17/07/23.

import Combine
import Foundation

class HomeViewModel: ObservableObject {
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  @Published var searchedText: String = ""

  private let dataService = CoinDataService()
  private var cancellables = Set<AnyCancellable>()

  init() {
    addSubscribers()
  }

  func addSubscribers() {
    dataService.$allCoins
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &cancellables)
  }
}
