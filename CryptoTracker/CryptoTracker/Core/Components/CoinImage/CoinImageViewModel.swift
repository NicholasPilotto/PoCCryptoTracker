// CoinImageViewModel.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 18/07/23.

import Combine
import Foundation
import SwiftUI

class CoinImageViewModel: ObservableObject {
  @Published var image: UIImage? = nil
  @Published var isLoading: Bool = false

  private let coin: CoinModel
  private let dataService: CoinImageService
  private var cancellables = Set<AnyCancellable>()

  init(coin: CoinModel) {
    self.coin = coin
    dataService = CoinImageService(coin: self.coin)
    addSubscribers()
    isLoading = true
  }

  private func addSubscribers() {
    dataService.$image
      .sink { [weak self] _ in
        self?.isLoading = false
      } receiveValue: { [weak self] returnedImage in
        self?.image = returnedImage
      }
      .store(in: &cancellables)
  }
}
