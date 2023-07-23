// MarketDataService.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 23/07/23.

import Combine
import Foundation

class MarketDataService {
  @Published var marketData: MarketDataModel? = nil

  var marketDataSubscription: AnyCancellable?

  init() {
    getData()
  }

  private func getData() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
      return
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    marketDataSubscription = NetworkingManager.download(url: url)
      .decode(type: GlobalData.self, decoder: decoder)
      .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in

        self?.marketData = receivedData.data
        self?.marketDataSubscription?.cancel()
      })
  }
}
