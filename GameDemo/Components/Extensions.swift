//
//  Extensions.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import Foundation
import SwiftUI

extension Text {
    func startButton() -> some View {
        self
            .padding()
            .background {
                Color.primary
            }
            .foregroundColor(.init(uiColor: .systemBlue))
            .cornerRadius(12)
            .foregroundStyle(.shadow(.drop(color: .black, radius: 12)))
    }
}
