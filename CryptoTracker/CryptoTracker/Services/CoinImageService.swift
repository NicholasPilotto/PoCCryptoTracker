// CoinImageService.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 18/07/23.

import Combine
import Foundation
import SwiftUI

class CoinImageService {
  @Published var image: UIImage?

  private var imageSubscription: AnyCancellable?
  private let coin: CoinModel
  private let fileManager = LocalFileManager.shared
  private let folderName = "coin_images"
  private let imageName: String

  init(coin: CoinModel) {
    self.coin = coin
    imageName = coin.id
    getCoinImage()
  }

  private func downloadCoinImage() {
    guard let url = URL(string: coin.image) else {
      return
    }

    imageSubscription = NetworkingManager.download(url: url)
      .tryMap { UIImage(data: $0) }
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] returnedImage in
        guard let self = self, let downloadedImage = returnedImage else {
          return
        }
        self.image = downloadedImage
        self.imageSubscription?.cancel()
        self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
      }
  }

  private func getCoinImage() {
    if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
      image = savedImage
    } else {
      downloadCoinImage()
    }
  }
}
