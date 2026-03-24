//
//  ContentView.swift
//  Goober Idle
//
//  Created by Not Assigned / ADAGE-154 on 3/3/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(GameEngine.self) private var gameEngine
    
    var body: some View {
        ZStack {
            // Set background color for the entire screen
            Color.teal
                .ignoresSafeArea() // Ensures the background covers the entire screen
            
            VStack {
                Spacer()
                
                // Tap count display
                Text("Tap Count: \(gameEngine.tapCount)")
                    .font(.largeTitle)
                    .padding()
                
                Button("Reset (Debug)"){
                    gameEngine.resetGame()
                }.padding(.bottom)
                
                
                // Tap Button
                Button {
                    gameEngine.clickGoober()
                } label: {
                    Image("Mischevious") // asset image
                        .resizable()
                        .frame(width: 250, height: 200) // adjust size as needed
                        .foregroundColor(.yellow)
                        .padding(.top)
                }
                
                ScrollView{
                    VStack(spacing: 20) {
                        ForEach(gameEngine.upgrades) { upgrade in
                            UpgradeRow(upgrade: upgrade, gameEngine: gameEngine)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 350)
                
                
                Spacer()
        
            }
        }
    }
}

struct UpgradeRow: View {
    let upgrade: Upgrade
    let gameEngine: GameEngine
    
    var body: some View {
        VStack {
            // The button logic talks directly to the engine
            Button("\(upgrade.name) Lvl \(upgrade.level) - Cost: \(upgrade.currentCost)") {
                gameEngine.buyUpgrade(id: upgrade.id)
            }
            .buttonStyle(.borderedProminent)
            .disabled(upgrade.currentCost > gameEngine.tapCount)
            .opacity(gameEngine.tapCount < upgrade.currentCost ? 0.6 : 1.0)
            
            // progress bar
            ProgressView(
                value: min(Double(gameEngine.tapCount), Double(upgrade.currentCost)),
                total: Double(upgrade.currentCost)
            )
            .tint(.yellow) // Progress bar color
        }
    }
}

#Preview {
    ContentView()
        .environment(GameEngine())
}
