//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 23/07/23.
//

import SwiftUI

struct PortfolioView: View {
  @Environment(\.isPresented) private var isPresented
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var viewModel: HomeViewModel
  
  @State private var selectedCoin: CoinModel? = nil
  
    var body: some View {
      NavigationView {
        ScrollView {
          VStack(alignment: .leading, spacing: 0) {
            SearchBarView(searchText: $viewModel.searchedText)
            
            ScrollView(.horizontal, showsIndicators: false) {
              LazyHStack(spacing: 10) {
                ForEach(viewModel.allCoins) { coin in
                  CoinLogoView(coin: coin)
                    .frame(width: 75)
                    .padding(4)
                    .onTapGesture {
                      withAnimation(.easeIn) {
                        selectedCoin = coin
                      }
                    }
                    .background(
                      RoundedRectangle(cornerRadius: 10)
                        .stroke(selectedCoin?.id == coin.id ?
                                Color.theme.green : Color.clear
                                , lineWidth: 1.0)
                      
                    )
                }
              }
              .padding(.vertical, 4)
              .padding(.leading)
            }
          }
        }
        .navigationTitle("Edit portfolio")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              if isPresented {
                dismiss()
              }
            } label: {
              Image(systemName: "xmark")
            }
          }
        }
      }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
        .environmentObject(dev.homeViewModel)
    }
}
