//
//  ChartView.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 05/08/23.
//

import SwiftUI

struct ChartView: View {
  let data: [Double]
  private let maxY: Double
  private let minY: Double
  private let lineColor: Color
  private let middlePrice: Double
  private let startingDate: Date
  private let endingDate: Date
  @State private var percentage: CGFloat = 0
  
  init(coin: CoinModel) {
    self.data = (coin.sparklineIn7D?.price ?? [])
    self.maxY = data.max() ?? 0
    self.minY = data.min() ?? 0
    
    lineColor = ((data.last ?? 0) - (data.first ?? 0)) > 0 ? Color.theme.green : Color.theme.red
    
    self.middlePrice = (maxY + minY) / 2
    
    self.endingDate = Date(coinGekoString: coin.lastUpdated ?? "")
    self.startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
  }
  
  var body: some View {
    VStack {
      chartView
        .frame(height: 200)
        .background(
          chartBackground
        )
        .overlay(alignment: .leading) {
          charYAxis
            .padding(.horizontal, 4)
        }
      
      chartDaysLables
        .padding(.horizontal, 4)
    }
    .font(.caption)
    .foregroundColor(Color.theme.secondaryText)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        withAnimation(.linear(duration: 2.0)) {
          percentage = 1.0
        }
      }
    }
  }
}

extension ChartView {
  private var chartView: some View {
    GeometryReader { geometry in
      Path { path in
        for index in data.indices {
          let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
          
          let yAxes = maxY - minY
          
          let yPosition = (1 - CGFloat((data[index] - minY) / yAxes)) * geometry.size.height
          
          if index == 0 {
            path.move(to: CGPoint(x: xPosition, y: yPosition))
          }
          
          path.addLine(to: CGPoint(x: xPosition, y: yPosition))
        }
      }
      .trim(from: 0, to: percentage)
      .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
      .shadow(color: lineColor, radius: 10, x: 0.0, y: 10.0)
      .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20.0)
      .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30.0)
      .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40.0)
    }
  }
  
  private var chartBackground: some View {
    VStack {
      Divider()
      Spacer()
      Divider()
      Spacer()
      Divider()
    }
  }
  
  private var charYAxis: some View {
    VStack {
      Text(maxY.formattedWithAbbreviations())
      Spacer()
      Text(middlePrice.formattedWithAbbreviations())
      Spacer()
      Text(minY.formattedWithAbbreviations())
    }
  }
  
  private var chartDaysLables: some View {
    HStack {
      Text(startingDate.asShortDayString())
      Spacer()
      Text(endingDate.asShortDayString())
    }
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    ChartView(coin: dev.coin)
  }
}
