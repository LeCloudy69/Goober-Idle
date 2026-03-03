//
//  ContentView.swift
//  Goober Clicker
//
//  Created by Not Assigned / ADAGE-154 on 3/3/26.
//

import SwiftUI

struct ContentView: View {
    @State var tapCount = 0
    @State var upgradeCount = 1 // Start with 1 upgrade multiplier
    
    // Base cost for the first upgrade
    let baseCost = 10
    
    // Exponential upgrade cost formula
    var upgradeCost: Int {
        return Int(pow(1.5, Double(upgradeCount))) * baseCost
    }
    
    var body: some View {
        ZStack {
            // Set background color for the entire screen
            Color.teal
                .ignoresSafeArea() // Ensures the background covers the entire screen
            
            VStack {
                Spacer()
                
                // Tap count display
                Text("Tap Count: \(tapCount)")
                    .font(.largeTitle)
                    .padding()
                
                // Upgrade multiplier display
                Text("Upgrade Multiplier: x\(upgradeCount)")
                    .font(.title2)
                    .padding(.top)
                
                Button("Reset"){
                    tapCount = 0
                    upgradeCount = 1
                }
                
                //Spacer()
                
                // Image in the center of the screen
                Image("Mischevious") // Example system image
                    .resizable()
                    .frame(width: 250, height: 200) // Adjust size as needed
                    .foregroundColor(.yellow)
                    .padding(.top)
                
                //Spacer()
                
                // Upgrade Button
                Button("Upgrade \(upgradeCount) for \(upgradeCost)") {
                    if tapCount >= upgradeCost {
                        tapCount -= upgradeCost
                        upgradeCount += 1 // Increase the multiplier
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top) // Dec11 update from 25 to top
                .disabled(upgradeCost > tapCount)
                .opacity(tapCount < upgradeCost ? 0.7 : 1.0)
                
                // Progress bar under the button
                ProgressView(value: Double(tapCount), total: Double(upgradeCost))
                    .padding(.horizontal)
                    .padding(.bottom)
                
                // Tap Button
                Button("Tap Me") {
                    tapCount += upgradeCount // Increase tap count by current upgrade multiplier
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
            }
            
            // Image in the center of the screen
            //Image("Mischevious") // Example system image
                //.resizable()
                //.frame(width: 250, height: 200) // Adjust size as needed
                //.foregroundColor(.yellow)
                //.position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        }
    }
}


#Preview {
    ContentView()
}
