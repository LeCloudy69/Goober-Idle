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
    var gooberCount: Int = 0
    var lifetimeCountGoobers: Int = 0
    
    var upgrades: [Upgrade] = []
    
    private var lastLogin: Date = Date.now
    private var timer: Timer?
    private var timerInterval: TimeInterval = 2.0
    
    init() {
        loadGame()
        startGameLoop()
    }
    
// MARK: - IN GAME TICK
    func startGameLoop() { // timer for in game ticks
        timer?.invalidate() // remove any previous timers
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
            self?.runTick()
        }
    }
    
    func runTick() {
        var totalGPS: Int = 0 // total goobers per second
        
        for upgrade in upgrades {
            totalGPS += upgrade.currentProduction
        }
        
        if totalGPS > 0 {
            gooberCount += totalGPS
            lifetimeCountGoobers += totalGPS
            print("added current gps: \(totalGPS)")
        }
    }
    
// MARK: - Game Logic
    func buyUpgrade(id: String) {
        // Find the index of the upgrade the player tapped
        if let index = upgrades.firstIndex(where: { $0.id == id }) {
            let upgrade = upgrades[index]
            
            if gooberCount >= upgrade.currentCost {
                gooberCount -= upgrade.currentCost
                upgrades[index].level += 1
            }
            saveGame()
        }
    }
    
    func clickGoober() {
        if let tap_upgrade = upgrades.first(where: { $0.id == "tap_power" }) {
            let earned = (1 + tap_upgrade.level)
            gooberCount += earned
            lifetimeCountGoobers += earned
        } else {
            gooberCount += 1 // fallback if tap_power doesnt exist
            lifetimeCountGoobers += 1
        }
        saveGame()
    }
    
    private func calculateOfflineProgress (from savedDate : Date){
        let secondsSinceGone = Date.now.timeIntervalSince(savedDate) // seconds since now from login
        guard secondsSinceGone > 120 else {
            print("Not gone long enough, no goobers")
            return
        } // if gone for less than 2 minutes, dont do nothing.
        var totalGPS = 0 // goobers Per Second
        for upgrade in upgrades {
            totalGPS += upgrade.currentProduction
        }
        let offlineGoobers = Int(secondsSinceGone) * totalGPS
        
        if offlineGoobers > 0 {
            gooberCount += offlineGoobers
            lifetimeCountGoobers += offlineGoobers
            print("Welcome Back, you earned \(offlineGoobers) while you were away!")
        }
        
    }
    
// MARK: - Debug / Reset
    func resetGame() {
        // 1. Reset the live variables back to their defaults
        self.gooberCount = 0
        self.lifetimeCountGoobers = 0
        self.upgrades = Upgrade.starterUpgrades
        saveGame()
    }
    
// MARK: - Persistence
    private func saveGame() {
        UserDefaults.standard.set(gooberCount, forKey: "gooberCount")
        UserDefaults.standard.set(lifetimeCountGoobers, forKey: "lifetimeCountGoobers")
        
        if let encodedData = try? JSONEncoder().encode(upgrades) {
            UserDefaults.standard.set(encodedData, forKey: "savedUpgrades")
        }
    }
    
    private func loadGame() {
        self.gooberCount = UserDefaults.standard.integer(forKey: "gooberCount")
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
    
// MARK: - App lifecycle

    func appWenttoBackground() {
        timer?.invalidate() // stop timer
        timer = nil // clear it from mem
        
        print("Game went to background, going to sleep")
        
        // saving time and saving game
        UserDefaults.standard.set(Date(), forKey: "lastLogin")
        saveGame()
    }
    
    func appCametoForeground() {
        print("Game woke up, checking for offline progress")
        if let savedDate = UserDefaults.standard.object(forKey: "lastLogin") as? Date {
            calculateOfflineProgress(from: savedDate)
            UserDefaults.standard.removeObject(forKey: "lastLogin")
        }
        
        startGameLoop() // we back, start ticking again.
    }
}



