//
//  GameDemoApp.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import SwiftUI

@main
struct QuizNETApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView(vm: QuestionVM())
        }
    }
}
