//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 15/07/23.
//

import SwiftUI

struct CoinRowView: View {
  let coin: CoinModel
  let showHoldingsColumn: Bool
  
  var body: some View {
    HStack(spacing: 0) {
      leftColumn
      
      Spacer()
      
      if showHoldingsColumn {
        centerColum
      }
      
      rightColum
    }
    .font(.subheadline)
  }
}

struct CoinRowView_Previews: PreviewProvider {
  static var previews: some View {
    CoinRowView(coin: dev.coin, showHoldingsColumn: true)
      .previewLayout(.sizeThatFits)
    
  }
}

extension CoinRowView {
  private var leftColumn: some View {
    HStack(spacing: 0) {
      Text("\(coin.rank)")
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .frame(minWidth: 30)
      
      Circle()
        .frame(width: 30, height: 30)
      
      Text(coin.symbol.uppercased())
        .font(.headline)
        .padding(.leading, 6)
        .foregroundColor(Color.theme.accent)
    }
  }
  
  private var centerColum: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentHoldingsValue.asCurrency())
        .foregroundColor(Color.theme.accent)
        .bold()
      
      Text((coin.currentHoldings ?? 0).asNumberString())
    }
  }
  
  private var rightColum: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentPrice.asCurrencyWith2Decimals())
        .bold()
        .foregroundColor(Color.theme.accent)
      
      Text((coin.priceChangePercentage24H ?? 0).asPercentString())
        .foregroundColor(
          (coin.priceChangePercentage24H ?? 0) >= 0 ?
          Color.theme.green : Color.theme.red
        )
    }
    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
  }
}
