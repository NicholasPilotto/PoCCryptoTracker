//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 03/08/23.
//

import SwiftUI

struct DetailLoadingView: View {
  @Binding var coin: CoinModel?
  
  var body: some View {
    ZStack {
      if let coin = coin {
        DetailView(coin: coin)
      }
    }
  }
}

struct DetailView: View {
  let coin: CoinModel
  @StateObject var viewModel: DetailViewModel
  private let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  private let spacing: CGFloat = 30
  
  init(coin: CoinModel) {
    self.coin = coin
    self._viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("")
          .frame(height: 150)
        
        overviewTitle
        Divider()
        overviewGrid
        
        additionalTitle
        Divider()
        additionalGrid
      }
      .padding()
    }
    .navigationTitle(viewModel.coin.name)
  }
}

extension DetailView {
  private var overviewTitle: some View {
    Text("Overview")
      .font(.title)
      .bold()
      .foregroundColor(Color.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var overviewGrid: some View {
    LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: []) {
      ForEach(viewModel.overviewStatistics) { stat in
        StatisticView(statistic: stat)
      }
    }
  }
  
  private var additionalTitle: some View {
    Text("Additional Details")
      .font(.title)
      .bold()
      .foregroundColor(Color.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var additionalGrid: some View {
    LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: []) {
      ForEach(viewModel.additionalStatistics) { stat in
        StatisticView(statistic: stat)
      }
    }
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(coin: dev.coin)
  }
}
