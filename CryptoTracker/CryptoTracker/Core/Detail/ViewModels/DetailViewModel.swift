//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 04/08/23.
//

import Combine
import Foundation

/// View model class to manage detail coin data and share it
/// with detail coin views
class DetailViewModel: ObservableObject {
  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  @Published var coin: CoinModel
  @Published var overviewStatistics: [StatisticModel] = []
  @Published var additionalStatistics: [StatisticModel] = []
  @Published var coinDescription: String?
  @Published var websiteURL: String?
  @Published var redditURL: String?
  
  init(coin: CoinModel) {
    self.coin = coin
    self.coinDetailService = CoinDetailDataService(coin: coin)
    self.addSubscribers()
  }
  
  private func addSubscribers() {
    coinDetailService.$coinDetails
      .combineLatest($coin)
      .map { [weak self] returnedCoinDetail, returnedCoinModel ->
        (overview: [StatisticModel], additional: [StatisticModel]) in
        guard let self = self else {
          return ([], [])
        }
        return self.mapDataToStatistics(coinDetailModel: returnedCoinDetail, coinModel: returnedCoinModel)
      }
      .sink { [weak self ]returnedArrays in
        self?.overviewStatistics = returnedArrays.overview
        self?.additionalStatistics = returnedArrays.additional
      }
      .store(in: &cancellables)
    
    coinDetailService.$coinDetails
      .sink { [weak self] returnedCoinDetails in
        self?.coinDescription = returnedCoinDetails?.readableDescription
        self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
        self?.redditURL = returnedCoinDetails?.links?.subredditUrl
      }
      .store(in: &cancellables)
  }
  
  private func mapDataToStatistics(
    coinDetailModel: CoinDetailModel?,
    coinModel: CoinModel
  ) -> (overview: [StatisticModel], additional: [StatisticModel]) {
    return (
      createOverviewArray(coinModel: coinModel),
      createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)
    )
  }
  
  private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
    // overview
    let price = coinModel.currentPrice.asCurrency()
    let pricePercentageChange = coinModel.priceChangePercentage24H
    let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
    let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
    let rank = "\(coinModel.rank)"
    let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
    
    return [
      StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange),
      StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentageChange),
      StatisticModel(title: "Rank", value: rank),
      StatisticModel(title: "Volume", value: volume)
    ]
  }
  
  private func createAdditionalArray(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticModel] {
    let high = (coinModel.high24H?.asCurrency() ?? "n/a")
    let low = (coinModel.low24H?.asCurrency() ?? "n/a")
    let priceChange = (coinModel.priceChange24H?.asCurrency() ?? "n/a")
    let pricePercentageChangeAdditional = coinModel.priceChangePercentage24H
    let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
    let marketCapPercentageChangeDetails = coinModel.marketCapChangePercentage24H
    let blockTime = "\(coinDetailModel?.blockTimeInMinutes ?? 0)"
    let hashing = coinDetailModel?.hashingAlgorithm ?? ""
    
    return  [
      StatisticModel(title: "24h High", value: high),
      StatisticModel(title: "24h Low", value: low),
      StatisticModel(
        title: "24 Price Change",
        value: priceChange,
        percentageChange: pricePercentageChangeAdditional
      ),
      StatisticModel(
        title: "24h Market Cap Change",
        value: marketCapChange,
        percentageChange: marketCapPercentageChangeDetails
      ),
      StatisticModel(title: "Block Time", value: blockTime),
      StatisticModel(title: "Hashing Algorithm", value: hashing)
    ]
  }
}
