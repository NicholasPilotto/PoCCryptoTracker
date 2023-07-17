//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 17/07/23.
//

import Foundation

class HomeViewModel: ObservableObject {
  @Published var allCoins: [CoinModel] = []
  @Published var portfolioCoins: [CoinModel] = []
  
  init() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      self.allCoins.append(DeveloperPreview.shared.coin)
      self.portfolioCoins.append(DeveloperPreview.shared.coin)
    }
  }
}
