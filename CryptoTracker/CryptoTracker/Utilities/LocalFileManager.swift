// LocalFileManager.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 20/07/23.

import Foundation
import UIKit

class LocalFileManager {
  static let shared = LocalFileManager()

  private init() {}

  private func getURLForFolder(folderName: String) -> URL? {
    let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first

    guard let url = url else {
      return nil
    }

    return url.appendingPathComponent(folderName)
  }

  private func getURLForImage(imageName: String, folderName: String) -> URL? {
    guard let folderURL = getURLForFolder(folderName: folderName) else {
      return nil
    }

    return folderURL.appendingPathComponent("\(imageName).png")
  }

  private func createFolderIfNeeded(folderName: String) {
    guard let url = getURLForFolder(folderName: folderName) else {
      return
    }

    if !FileManager.default.fileExists(atPath: url.path) {
      do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
      } catch {
        print("Error creating directory: \(error.localizedDescription)")
      }
    }
  }

  /// Save coin image
  ///
  /// This is function used to store coin image inside a cache file to avoid to download
  /// it multiple times
  ///
  /// - Parameters:
  ///   - image: Image to store
  ///   - imageName: Name of the image to store
  ///   - folderName: Name of the folder that will contain the image
  /// - Authors: Nicholas Pilotto
  /// - Since: 1.0
  public func saveImage(image: UIImage, imageName: String, folderName: String) {
    createFolderIfNeeded(folderName: folderName)

    guard let data = image.pngData(),
      let url = getURLForImage(imageName: imageName, folderName: folderName) else {
      return
    }

    do {
      try data.write(to: url)
    } catch {
      print("Error while save image into file: \(error.localizedDescription)")
    }
  }

  /// Get the image from a cache file
  ///
  /// This is a function used to get the image from the file if the image has
  /// already be downloaded
  ///
  /// - Parameters:
  ///   - imageName: Name of the image to get
  ///   - folderName: Name of the folder to looking for the image
  /// - Returns: image as ``UIImage?`` if the image has been already be downloaded, ``nil``
  /// otherwise
  /// - Authors: Nicholas Pilotto
  /// - Since: 1.0
  public func getImage(imageName: String, folderName: String) -> UIImage? {
    guard let url = getURLForImage(imageName: imageName, folderName: folderName),
      FileManager.default.fileExists(atPath: url.path) else {
      return nil
    }

    return UIImage(contentsOfFile: url.path)
  }
}
