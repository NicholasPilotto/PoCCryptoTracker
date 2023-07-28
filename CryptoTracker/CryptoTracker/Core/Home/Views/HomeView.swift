// HomeView.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 13/07/23.

import SwiftUI

struct HomeView: View {
  @EnvironmentObject private var viewModel: HomeViewModel
  /// animate transition to portfolio view
  @State private var showPortfolio = false
  /// show portfolio view
  @State private var showPortfolioView = false

  var body: some View {
    ZStack {
      Color.theme.background
        .ignoresSafeArea()
        .sheet(isPresented: $showPortfolioView) {
          PortfolioView()
            .environmentObject(viewModel)
        }

      VStack {
        homeHeader

        HomeStatsView(showPortfolio: $showPortfolio)

        SearchBarView(searchText: $viewModel.searchedText)

        columnsTitles

        if !showPortfolio {
          allCoinList
            .transition(.move(edge: .leading))
        } else {
          portfolioCoinList
            .transition(.move(edge: .trailing))
        }

        Spacer(minLength: 0)
      }
    }
  }
}

extension HomeView {
  private var homeHeader: some View {
    HStack {
      CircleButtonView(iconeName: showPortfolio ? "plus" : "info")
        .transaction { transaction in
          transaction.animation = nil
        }
        .background {
          CircleButtonAnimationView(animate: $showPortfolio)
        }
        .onTapGesture {
          if showPortfolio {
            showPortfolioView.toggle()
          }
        }

      Spacer()

      Text(showPortfolio ? "Portfolio" : "Live prices")
        .font(.headline)
        .fontWeight(.heavy)
        .foregroundColor(Color.theme.accent)
        .transaction { transaction in
          transaction.animation = nil
        }

      Spacer()

      CircleButtonView(iconeName: "chevron.right")
        .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
        .onTapGesture {
          withAnimation(.spring()) {
            showPortfolio.toggle()
          }
        }
    }
    .padding(.horizontal)
  }

  private var allCoinList: some View {
    List {
      ForEach(viewModel.allCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: false)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
      }
    }
    .listStyle(.plain)
  }

  private var portfolioCoinList: some View {
    List {
      ForEach(viewModel.portfolioCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: true)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
      }
    }
    .listStyle(.plain)
  }

  private var columnsTitles: some View {
    HStack {
      Text("Coin")
      Spacer()
      if showPortfolio {
        Text("Holdings")
      }
      Text("Price")
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)

      Button {
        withAnimation(.linear(duration: 2.0)) {
          viewModel.reloadData()
        }
      } label: {
        Image(systemName: "goforward")
      }
      .rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0), anchor: .center)
    }
    .font(.caption)
    .foregroundColor(Color.theme.secondaryText)
    .padding(.horizontal)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
        .navigationBarHidden(true)
    }
    .environmentObject(dev.homeViewModel)
  }
}
