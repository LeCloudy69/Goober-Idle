//
//  Goober_IdleApp.swift
//  Goober Idle
//
//  Created by Not Assigned / ADAGE-154 on 3/3/26.
//

import SwiftUI

@main
struct Goober_IdleApp: App {
    @Environment(\.scenePhase) private var scenePhase
    // 1. Create the single "Source of Truth" for the entire game
    @State private var gameEngine = GameEngine()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // 2. Inject it into the environment so any view can access it
                .environment(gameEngine)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                // User swiped home or locked their phone
                gameEngine.appWenttoBackground()
            } else if scenePhase == .active {
                // User is actively looking at the game again
                gameEngine.appCametoForeground()
            }
        }
    }
}
