//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 10/07/23.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    var body: some Scene {
        WindowGroup {
          NavigationView {
            HomeView()
              .navigationBarHidden(true)
          }
        }
    }
}
