//
//  WelcomeView.swift
//  GameDemo
//
//  Created by Patrick Alves on 09.02.23.
//

import Foundation

final class LaunchScreenVM: ObservableObject {

@MainActor
@Published private(set) var state: LaunchScreenStep = .start
@Published var stopLaunch: Bool = false

    @MainActor
    func dismiss() {
        Task {
            try? await Task.sleep(for: Duration.seconds(1))

            self.state = .finished
        }
    }
}
