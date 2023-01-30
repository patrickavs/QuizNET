//
//  Extensions.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import Foundation
import SwiftUI


extension Text {
    /// This Function describes how the startbutton looks like
    /// - Returns: Returns a Button-View
    func startButton() -> some View {
        self
            .padding()
            .padding(.horizontal, 30)
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .foregroundColor(.black)
            .cornerRadius(12)
    }
}
