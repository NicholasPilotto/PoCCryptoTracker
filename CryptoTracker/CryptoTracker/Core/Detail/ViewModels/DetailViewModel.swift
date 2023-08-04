//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 04/08/23.
//

import Combine
import Foundation

class DetailViewModel: ObservableObject {
  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: CoinModel) {
    self.coinDetailService = CoinDetailDataService(coin: coin)
  }
  
  private func addSubscribers() {
    coinDetailService.$coinDetails
      .sink { returnedCoinDetails in
        print("received coin details: \(returnedCoinDetails?.id ?? "")")
      }
      .store(in: &cancellables)
  }
}
