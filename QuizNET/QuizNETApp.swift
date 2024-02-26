//
//  GameDemoApp.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import SwiftUI

@main
struct QuizNETApp: App {
    @StateObject var launchScreenState = LaunchScreenVM()
    var body: some Scene {
        WindowGroup {
            ZStack {
                WelcomeView(vm: QuestionVM())
                
                if !launchScreenState.stopLaunch {
                    if launchScreenState.state != .finished {
                        LaunchScreenView()
                    }
                }
            }.environmentObject(launchScreenState)
        }
    }
}
