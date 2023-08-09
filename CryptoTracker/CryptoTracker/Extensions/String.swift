//
//  String.swift
//  CryptoTracker
//
//  Created by Nicholas Pilotto on 09/08/23.
//

import Foundation

extension String {
  var removingHtmlOccurencies: String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }
}
