// PortfolioDataService.swift
// Copyright (c) 2023
// Created by Nicholas Pilotto on 26/07/23.

import CoreData
import Foundation

class PortfolioDataService {
  private let container: NSPersistentContainer
  private let containerName: String = "PortfolioContainer"
  private let entityName: String = "PortfolioEntity"

  @Published var savedEntities: [PortfolioEntity] = []

  init() {
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { _, error in
      if let error = error {
        print("Error loading Core Data \(error)")
      }
      self.getPortfolio()
    }
  }

  private func getPortfolio() {
    let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)

    do {
      savedEntities = try container.viewContext.fetch(request)
    } catch {
      print("Error fetching portfolio entities: \(error)")
    }
  }

  private func save() {
    do {
      try container.viewContext.save()
    } catch {
      print("Error saving to Core Data: \(error)")
    }
  }

  private func applyChanges() {
    save()
    getPortfolio()
  }

  private func add(coin: CoinModel, amount: Double) {
    let entity = PortfolioEntity(context: container.viewContext)
    entity.coinID = coin.id
    entity.amount = amount
    applyChanges()
  }

  private func update(entity: PortfolioEntity, amount: Double) {
    entity.amount = amount
    applyChanges()
  }

  private func delete(entity: PortfolioEntity) {
    container.viewContext.delete(entity)
    applyChanges()
  }

  public func updatePortfolio(coin: CoinModel, amount: Double) {
    // check if coin is already present in portfolio
    if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
      if amount > 0 {
        update(entity: entity, amount: amount)
      } else {
        delete(entity: entity)
      }
    } else {
      add(coin: coin, amount: amount)
    }
  }
}
