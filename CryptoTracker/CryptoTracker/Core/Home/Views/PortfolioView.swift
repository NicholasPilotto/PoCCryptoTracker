// PortfolioView.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 23/07/23.

import SwiftUI

struct PortfolioView: View {
  @Environment(\.isPresented) private var isPresented
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var viewModel: HomeViewModel

  @State private var selectedCoin: CoinModel? = nil
  @State private var quatityText: String = ""
  @State private var showCheckmark: Bool = false

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          SearchBarView(searchText: $viewModel.searchedText)

          coinLogoList

          if selectedCoin != nil {
            portfolioInputSection
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
        ToolbarItem(placement: .navigationBarTrailing) {
          trailingNavbarButton
        }
      }
      .onChange(of: viewModel.searchedText) { value in
        if value == "" {
          removeSelectedCoin()
        }
      }
    }
  }
}

extension PortfolioView {
  private var coinLogoList: some View {
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
                  Color.theme.green : Color.clear,
                  lineWidth: 1.0)
            )
        }
      }
      .frame(height: 120)
      .padding(.leading)
    }
  }

  private var portfolioInputSection: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
        Spacer()
        Text(selectedCoin?.currentPrice.asCurrency() ?? "")
      }

      Divider()

      HStack {
        Text("Amount holding:")
        Spacer()
        TextField("Ex: 1.4", text: $quatityText)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
      }

      Divider()

      HStack {
        Text("Current value:")
        Spacer()
        Text(getCurrentValue().asCurrencyWith2Decimals())
      }
    }
    .transaction { transaction in
      transaction.animation = nil
    }
  }

  private var trailingNavbarButton: some View {
    HStack(spacing: 10) {
      Image(systemName: "checkmark")
        .opacity(showCheckmark ? 1.0 : 0.0)
        .foregroundColor(Color.theme.accent)
      Button {
        saveButtonPressed()
      } label: {
        Text("Save".uppercased())
      }
      .opacity(
        (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quatityText)) ? 1.0 : 0.0
      )
    }
    .font(.headline)
  }

  private func getCurrentValue() -> Double {
    if let quantity = Double(quatityText) {
      return quantity * (selectedCoin?.currentPrice ?? 0)
    }

    return 0
  }

  private func saveButtonPressed() {
    guard let coin = selectedCoin else {
      return
    }

    withAnimation(.easeIn) {
      showCheckmark = true
      removeSelectedCoin()
    }

    // hide keyboard
    UIApplication.shared.endEditing()

    // hide checkmark
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      withAnimation(.easeOut) {
        showCheckmark = false
      }
    }
  }

  private func removeSelectedCoin() {
    selectedCoin = nil
    viewModel.searchedText = ""
  }
}

struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(dev.homeViewModel)
  }
}
