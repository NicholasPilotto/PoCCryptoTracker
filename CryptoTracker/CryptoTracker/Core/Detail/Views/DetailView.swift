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
  @State private var showFullDescription = false
  
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
      VStack {
        ChartView(coin: viewModel.coin)
          .padding(.vertical)
        VStack(spacing: 20) {
          overviewTitle
          Divider()
          
          descriptionSection
          
          overviewGrid
          additionalTitle
          Divider()
          additionalGrid
          
          websiteSection
        }
        .padding()
      }
    }
    .background(Color.theme.background.ignoresSafeArea())
    .navigationTitle(viewModel.coin.name)
    .navigationBarTitleDisplayMode(.large)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        navigationBarTrailingItems
      }
    }
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
  
  private var navigationBarTrailingItems: some View {
    HStack {
      Text(viewModel.coin.symbol.uppercased())
        .font(.headline)
        .foregroundColor(Color.theme.secondaryText)
      
      CoinImageView(coin: viewModel.coin)
        .frame(width: 25, height: 25)
    }
  }
  
  private var descriptionSection: some View {
    ZStack {
      if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
        VStack(alignment: .leading) {
          Text(coinDescription)
            .lineLimit(showFullDescription ? nil : 3)
            .font(.callout)
            .foregroundColor(Color.theme.secondaryText)
          
          Button {
            withAnimation(.easeInOut) {
              showFullDescription.toggle()
            }
          } label: {
            Text(showFullDescription ? "Read less..." : "Read more...")
              .font(.caption)
              .fontWeight(.bold)
              .padding(.vertical, 4)
          }
          .tint(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
  
  private var websiteSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      if let website = viewModel.websiteURL, let url = URL(string: website) {
        Link("Website", destination: url)
      }
      
      if let reddit = viewModel.redditURL, let url = URL(string: reddit) {
        Link("Reddit", destination: url)
      }
    }
    .tint(.blue)
    .frame(maxWidth: .infinity, alignment: .leading)
    .font(.headline)
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(coin: dev.coin)
  }
}
