//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 04/08/23.
//

import Combine
import Foundation

class CoinDetailDataService {
  @Published var coinDetails: CoinDetailModel?

  var coinDetailSubscription: AnyCancellable?
  let coin: CoinModel

  init(coin: CoinModel) {
    self.coin = coin
    getCoinDetails()
  }

  func getCoinDetails() {
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
      return
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    coinDetailSubscription = NetworkingManager.download(url: url)
      .decode(type: CoinDetailModel.self, decoder: decoder)
      .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedCoinsDetails in
        self?.coinDetails = returnedCoinsDetails
        self?.coinDetailSubscription?.cancel()
      }
  }
}
