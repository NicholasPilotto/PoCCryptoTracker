// NetworkingManager.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 18/07/23.

import Combine
import Foundation

enum NetworkingManager {
  /// Identify the type of the error that can be occur on a network call
  /// - Authors: Nicholas Pilotto
  /// - Parameters
  ///   - badURLResponse: URL has a bed response
  ///   - unknown: Generic networking error
  enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown

    var errorDescription: String? {
      switch self {
        case let .badURLResponse(url: url): return "Bad response from URL \(url)"
        case .unknown: return "Unknown error occured"
      }
    }
  }

  /// Download data from a specific URL
  ///
  /// This is a **static** method, used to retrieve data calling a specific URL
  ///
  /// - Parameters:
  ///     - url: URL of the resources
  ///
  /// - Returns: Publisher with output of type **Data** and **Error** as error
  ///
  /// - Authors: Nicholas Pilotto
  ///
  /// - Since: 1.0
  static func download(url: URL) -> AnyPublisher<Data, Error> {
    return URLSession.shared.dataTaskPublisher(for: url)
      .subscribe(on: DispatchQueue.global(qos: .default))
      .tryMap { try handleURLResponse(output: $0, url: url) }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  /// Handle URL response
  ///
  /// This is a **static** method used to handle every URL reponse coming back from
  /// ``download(url:)``
  ///
  /// - Parameters:
  ///   - output: Type of the publisher
  ///   - url: URL of the request
  /// - Throws: ``NetworkingError`` representing the type of the occurred error
  /// - Returns: ``Data`` got form the URL
  /// - Authors: Nicholas Pilotto
  /// - Since: 1.0
  static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
    guard let response = output.response as? HTTPURLResponse,
      response.statusCode >= 200 && response.statusCode < 300 else {
      throw NetworkingError.badURLResponse(url: url)
    }

    return output.data
  }

  /// Handle request completion
  ///
  /// This is a static function used to handle request completion
  ///
  /// - Parameters:
  ///   - completion: Completion executed on request received
  /// - Authors: Nicholas Pilotto
  /// - Since: 1.0
  static func handleCompletion(completion: Subscribers.Completion<Error>) {
    switch completion {
      case .finished:
        break
      case let .failure(error):
        print(error.localizedDescription)
    }
  }
}
