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
  
  init(coin: CoinModel) {
    self.coin = coin
    self._viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
  }
  
  var body: some View {
    Text(coin.name)
  }
}

struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(coin: dev.coin)
  }
}
