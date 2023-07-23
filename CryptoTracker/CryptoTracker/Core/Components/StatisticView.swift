// StatisticView.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 22/07/23.

import SwiftUI

struct StatisticView: View {
  let statistic: StatisticModel
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(statistic.title)
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)

      Text(statistic.value)
        .font(.headline)
        .foregroundColor(Color.theme.accent)

      HStack {
        Image(systemName: "triangle.fill")
          .font(.caption2)
          .rotationEffect(
            Angle(degrees: (statistic.percentageChange ?? 0) >= 0
              ? 0 : 180))

        Text(statistic.percentageChange?.asPercentString() ?? "")
          .font(.caption)
          .bold()
      }
      .foregroundColor((statistic.percentageChange ?? 0) >= 0
        ? Color.theme.green : Color.theme.red)
      .opacity(statistic.percentageChange == nil ? 0.0 : 1.0)
    }
  }
}

struct StatisticView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      StatisticView(statistic: dev.statistic1)
        .previewLayout(.sizeThatFits)
      StatisticView(statistic: dev.statistic2)
        .previewLayout(.sizeThatFits)
      StatisticView(statistic: dev.statistic3)
        .previewLayout(.sizeThatFits)
    }
  }
}
