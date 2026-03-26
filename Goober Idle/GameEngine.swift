//
//  GameEngine.swift
//  Goober Idle
//
//  Created by Not Assigned / ADAGE-154 on 3/21/26.
//

import Foundation

import SwiftUI
import Observation // Required for @Observable in iOS 17+

@Observable
class GameEngine {
    var tapCount: Int = 0
    var lifetimeCountGoobers: Int = 0
    
    var upgrades: [Upgrade] = []
    
    init() {
        loadGame()
    }
    
    // MARK: - Game Logic
    func buyUpgrade(id: String) {
        // Find the index of the upgrade the player tapped
        if let index = upgrades.firstIndex(where: { $0.id == id }) {
            let upgrade = upgrades[index]
            
            if tapCount >= upgrade.currentCost {
                tapCount -= upgrade.currentCost
                upgrades[index].level += 1
            }
            saveGame()
        }
    }
    
    func clickGoober() {
        if let tap_upgrade = upgrades.first(where: { $0.id == "tap_power" }) {
            let earned = (1 + tap_upgrade.level)
            tapCount += earned
            lifetimeCountGoobers += earned
        } else {
            tapCount += 1 // fallback if tap_power doesnt exist
            lifetimeCountGoobers += 1
        }
        saveGame()
    }
    
    // MARK: - Debug / Reset
    func resetGame() {
        // 1. Reset the live variables back to their defaults
        self.tapCount = 0
        self.lifetimeCountGoobers = 0
        self.upgrades = Upgrade.starterUpgrades
        saveGame()
    }
    
    // MARK: - Persistence
    private func saveGame() {
        UserDefaults.standard.set(tapCount, forKey: "tapCount")
        UserDefaults.standard.set(lifetimeCountGoobers, forKey: "lifetimeCountGoobers")
        
        if let encodedData = try? JSONEncoder().encode(upgrades) {
            UserDefaults.standard.set(encodedData, forKey: "savedUpgrades")
        }
    }
    
    private func loadGame() {
        self.tapCount = UserDefaults.standard.integer(forKey: "tapCount")
        self.lifetimeCountGoobers = UserDefaults.standard.integer(forKey: "lifetimeCountGoobers")
            
        if let savedData = UserDefaults.standard.data(forKey: "savedUpgrades"),
            let decodedUpgrades = try? JSONDecoder().decode([Upgrade].self, from: savedData),
            !decodedUpgrades.isEmpty {
            self.upgrades = decodedUpgrades
        } else {
            // First time or empty save, Initialize the default upgrade list
            self.upgrades = Upgrade.starterUpgrades
        }
        saveGame()
    }
}
