//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 13/07/23.
//

import SwiftUI

struct HomeView: View {
  @State private var showPortfolio: Bool = false
  
    var body: some View {
      ZStack {
        Color.theme.background
          .ignoresSafeArea()
        
        VStack {
          homeHeader
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
        HomeView()
          .navigationBarHidden(true)
      }
    }
}
