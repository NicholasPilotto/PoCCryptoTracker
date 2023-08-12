// CryptoTrackerApp.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 10/07/23.

import SwiftUI

@main
struct CryptoTrackerApp: App {
  @StateObject private var viewModel = HomeViewModel()
  @State private var showLaunchView = true

  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
  }

  var body: some Scene {
    WindowGroup {
      ZStack {
        NavigationStack {
          HomeView()
            .navigationBarHidden(true)
        }
        .environmentObject(viewModel)
        
        ZStack {
          if showLaunchView {
            LaunchView(showLaunchView: $showLaunchView)
              .transition(.move(edge: .leading))
          }
        }
        .zIndex(2.0)
      }
    }
  }
}
