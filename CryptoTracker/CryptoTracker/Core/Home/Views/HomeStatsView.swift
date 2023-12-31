// HomeStatsView.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 22/07/23.

import SwiftUI

struct HomeStatsView: View {
  @EnvironmentObject var viewModel: HomeViewModel
  @Binding var showPortfolio: Bool

  var body: some View {
    HStack {
      ForEach(viewModel.statistics) { stat in
        StatisticView(statistic: stat)
          .frame(width: UIScreen.main.bounds.width / 3)
      }
    }
    .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
  }
}

struct HomeStatsView_Previews: PreviewProvider {
  static var previews: some View {
    HomeStatsView(showPortfolio: .constant(false))
  }
}
