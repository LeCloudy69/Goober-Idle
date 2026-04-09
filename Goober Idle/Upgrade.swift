//
//  Upgrade.swift
//  Goober Idle
//
//  Created by Not Assigned / ADAGE-154 on 3/21/26.
//

import Foundation

struct Upgrade: Identifiable, Codable {
    let id: String           // Unique string id like "tap_power"
    let name: String         // Display name like "Goober Farm"
    let description: String  // "Generates 1 Goober per second"
    let baseCost: Int
    let multiplier: Double   // How much the cost multiplies per level
    let baseProduction: Int
    let unlockThreshold: Int
    
    var level: Int = 0       // upgrade level
    
    
    // Computed property: Calculates cost dynamically based on current level
    var currentCost: Int {
        return Int(Double(baseCost) * pow(multiplier, Double(level)))
    }
    
    // Computed property: Calculates production based on level
    var currentProduction: Int {
        return level > 0 ? level * baseProduction : 0
    }
    
    var buttonTitle: String {
        if level == 0 {
            return "Unlock: \(name) Lvl 1 - Cost: \(currentCost)"
        }
        else {
            return name + " Lvl \(level)  - Cost: \(currentCost)"
        }
    }
    
    // MARK: - Default Data
        // "static" we cant change this, this isnt part of anything
        static let starterUpgrades: [Upgrade] = [
            // Tap En-Gooberment, Always visible, Increases Goobers per click
            Upgrade(id: "tap_power", name: "Tap En-Gooberment", description: "+1 per tap", baseCost: 10, multiplier: 1.5, baseProduction: 0, unlockThreshold: 0),
            // Goober Farm, threshhold, First idle upgrade
            Upgrade(id: "auto_farm", name: "Goober Farm", description: "Auto-generates", baseCost: 50, multiplier: 1.8, baseProduction: 5, unlockThreshold: 25),
            // Goober Factory, threshhold, Second idle upgrade
            Upgrade(id: "goober_factory", name: "Goober Factory", description: "Mass production", baseCost: 500, multiplier: 2.0, baseProduction: 50, unlockThreshold: 300)
        ]
}
