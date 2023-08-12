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
  
  @State private var selectedCoin: CoinModel?
  @State private var showDetailView = false
  
  @State private var showSettingsView = false

  var body: some View {
    NavigationStack {
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
            ZStack(alignment: .top) {
              if viewModel.portfolioCoins.isEmpty, viewModel.searchedText.isEmpty {
                portfolioEmptyText
              } else {
                portfolioCoinList
              }
            }
            .transition(.move(edge: .trailing))
          }
          
          Spacer(minLength: 0)
        }
        .sheet(isPresented: $showSettingsView) {
          SettingsView()
        }
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
          } else {
            showSettingsView.toggle()
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
    NavigationStack {
      List {
        ForEach(viewModel.allCoins) { coin in
          CoinRowView(coin: coin, showHoldingsColumn: false)
            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            .onTapGesture {
              segue(coin: coin)
            }
        }
        .navigationDestination(isPresented: $showDetailView) {
          DetailLoadingView(coin: $selectedCoin)
        }
      }
      .listStyle(.plain)
    }
  }

  private var portfolioCoinList: some View {
    List {
      ForEach(viewModel.portfolioCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: true)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
          .onTapGesture {
            segue(coin: coin)
          }
      }
      .navigationDestination(isPresented: $showDetailView) {
        DetailLoadingView(coin: $selectedCoin)
      }
    }
    .listStyle(.plain)
  }
  
  private var portfolioEmptyText: some View {
    Text("You haven't added any coins to your portfolio yet! Click the + button to get started! 🧐")
      .font(.callout)
      .fontWeight(.medium)
      .foregroundColor(Color.theme.accent)
      .multilineTextAlignment(.center)
      .padding(50)
  }

  private var columnsTitles: some View {
    HStack {
      HStack(spacing: 4) {
        Text("Coin")
        Image(systemName: "chevron.down")
          .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0)
          .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
      }
      .onTapGesture {
        withAnimation(.default) {
          viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
        }
      }
      
      Spacer()
      if showPortfolio {
        HStack {
          Text("Holdings")
          Image(systemName: "chevron.down")
            .opacity((viewModel.sortOption == .holdings || viewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0)
            .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
        }
        .onTapGesture {
          withAnimation(.default) {
            viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
          }
        }
      }
      
      HStack {
        Text("Price")
        Image(systemName: "chevron.down")
          .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed ) ? 1.0 : 0.0)
          .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
      }
      .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
      .onTapGesture {
        withAnimation(.default) {
          viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
        }
      }

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
  
  private func segue(coin: CoinModel) {
    selectedCoin = coin
    showDetailView.toggle()
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
