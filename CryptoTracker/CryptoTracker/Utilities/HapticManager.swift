// HapticManager.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 27/07/23.

import Foundation
import SwiftUI

class HapticManager {
  private static let generator = UINotificationFeedbackGenerator()

  static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    generator.notificationOccurred(type)
  }
}
