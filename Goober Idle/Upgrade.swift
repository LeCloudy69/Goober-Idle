//
//  Upgrade.swift
//  Goober Idle
//
//  Created by Not Assigned / ADAGE-154 on 3/21/26.
//

import Foundation

struct Upgrade: Identifiable, Codable {
    let id: String           // Unique string id like "auto_clicker_1"
    let name: String         // Display name like "Goober Farm"
    let description: String  // "Generates 1 Goober per second"
    let baseCost: Int
    let multiplier: Double   // How much the cost multiplies per level
    var level: Int = 0       // This is the dynamic part that changes
    
    // Computed property: Calculates cost dynamically based on current level
    var currentCost: Int {
        return Int(Double(baseCost) * pow(multiplier, Double(level)))
    }
    
    // Computed property: Calculates production based on level
    var currentProduction: Int {
        // Example: Level 1 = 1/sec, Level 2 = 2/sec. Adjust formula as needed.
        return level > 0 ? level * 1 : 0
    }
    
    // MARK: - Default Data
        // "static" we cant change this, this isnt part of anything
        static let starterUpgrades: [Upgrade] = [
            Upgrade(id: "tap_power", name: "Tap En-Gooberment", description: "+1 per tap", baseCost: 10, multiplier: 1.5),
            Upgrade(id: "auto_farm", name: "Goober Farm", description: "Auto-generates", baseCost: 50, multiplier: 1.8),
            Upgrade(id: "factory", name: "Goober Factory", description: "Mass production", baseCost: 500, multiplier: 2.0)
        ]
}
