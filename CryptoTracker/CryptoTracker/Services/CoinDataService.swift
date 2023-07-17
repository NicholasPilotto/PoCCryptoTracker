//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 17/07/23.
//

import Foundation
import Combine

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
    
    var decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
      .subscribe(on: DispatchQueue.global(qos: .default))
      .tryMap { (output) -> Data in
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
              }
        
        return output.data
      }
      .receive(on: DispatchQueue.main)
      .decode(type: [CoinModel].self, decoder: decoder)
      .sink { (completion) in
        switch completion {
          case .finished:
            break
          case .failure(let error):
            print(error.localizedDescription)
            break
        }
      } receiveValue: { [weak self] (returnedCoins) in
        self?.allCoins = returnedCoins
        self?.coinSubscription?.cancel()
      }

  }
}
