//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 11/08/23.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.isPresented) private var isPresented
  @Environment(\.dismiss) private var dismiss
  
  let defaultUrl = URL(string: "https://www.google.com")
  let youtubeUrl = URL(string: "https://www.youtube.com")
  let cofeeUrl = URL(string: "https://www.google.com")
  let coingeckoUrl = URL(string: "https://www.coingecko.com")
  let personalUrl = URL(string: "https://www.google.com")
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.theme.background.ignoresSafeArea()
        List {
          swiftfulThinkingSection
            .listRowBackground(Color.theme.background.opacity(0.5))
          coingeckoSection
            .listRowBackground(Color.theme.background.opacity(0.5))
          developerSection
            .listRowBackground(Color.theme.background.opacity(0.5))
          applicationSection
            .listRowBackground(Color.theme.background.opacity(0.5))
        }
        .listStyle(.grouped)
        .tint(.blue)
        .navigationTitle("Settings")
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
}

extension SettingsView {
  private var swiftfulThinkingSection: some View {
    Section(header: Text("Swiftful thinking")) {
      VStack(alignment: .leading) {
        Image("logo")
          .resizable()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
          Text("This app was made by following swiftful think course on youtube")
          .fontWeight(.medium)
          .foregroundColor(Color.theme.accent)
      }
      .padding(.vertical)
      if let url = youtubeUrl {
        Link(destination: url) {
          Text("Subscribe on YouTube")
        }
      }
      
      if let url = cofeeUrl {
        Link(destination: url) {
          Text("Buy me a coffee")
        }
      }
    }
  }
  
  private var coingeckoSection: some View {
    Section(header: Text("Coin Gecko")) {
      VStack(alignment: .leading) {
        Image("coingecko")
          .resizable()
          .scaledToFit()
          .frame(height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
          Text("The cryptocurrency data that is used in this app comes from CoinGecko API")
          .fontWeight(.medium)
          .foregroundColor(Color.theme.accent)
      }
      .padding(.vertical)
      if let url = coingeckoUrl {
        Link(destination: url) {
          Text("Visit Coin Gecko")
        }
      }
    }
  }
  
  private var developerSection: some View {
    Section(header: Text("Developer")) {
      VStack(alignment: .leading) {
        Image("logo")
          .resizable()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
          Text("This app is developed by Nicholas Pilotto. It uses SwiftUI and is written 100% Swift")
          .fontWeight(.medium)
          .foregroundColor(Color.theme.accent)
      }
      .padding(.vertical)
      if let url = personalUrl {
        Link(destination: url) {
          Text("Visit website")
        }
      }
    }
  }
  
  private var applicationSection: some View {
    Section(header: Text("Application")) {
      if let url = defaultUrl {
        Link(destination: url) {
          Text("Term of service")
        }
      }
      
      if let url = defaultUrl {
        Link(destination: url) {
          Text("Privacy policy")
        }
      }
      
      if let url = defaultUrl {
        Link(destination: url) {
          Text("Company website")
        }
      }
      if let url = defaultUrl {
        Link(destination: url) {
          Text("Learn more")
        }
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
