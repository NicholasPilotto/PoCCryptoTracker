// UIApplication.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 21/07/23.

import Foundation
import UIKit

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
