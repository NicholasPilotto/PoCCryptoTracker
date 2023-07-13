//
//  CircleButtonView.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 13/07/23.
//

import SwiftUI

struct CircleButtonView: View {
  let iconeName: String
  var body: some View {
    Image(systemName: iconeName)
      .font(.headline)
      .foregroundColor(Color.theme.accent)
      .frame(width: 50, height: 50)
      .background(
        Circle()
          .foregroundColor(Color.theme.background)
      )
      .shadow(color: Color.theme.accent.opacity(0.25), radius: 10, x: 0, y: 0 )
      .padding()
  }
}

struct CircleButtonView_Previews: PreviewProvider {
  static var previews: some View {
    CircleButtonView(iconeName: "heart.fill")
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
