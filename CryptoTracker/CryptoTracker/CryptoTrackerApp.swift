// CryptoTrackerApp.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 10/07/23.

import SwiftUI

@main struct CryptoTrackerApp: App {
  @StateObject private var viewModel = HomeViewModel()
  
  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
  }

  var body: some Scene {
    WindowGroup {
      NavigationView {
        HomeView()
          .navigationBarHidden(true)
      }
      .environmentObject(viewModel)
    }
  }
}
