// StatisticModel.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 22/07/23.

import Foundation

struct StatisticModel: Identifiable {
  let id = UUID().uuidString
  let title: String
  let value: String
  let percentageChange: Double?

  init(title: String, value: String, percentageChange: Double? = nil) {
    self.title = title
    self.value = value
    self.percentageChange = percentageChange
  }
}
