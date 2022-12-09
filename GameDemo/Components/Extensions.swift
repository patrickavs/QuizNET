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
            .padding(.horizontal, 30)
            .background {
                LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            .foregroundColor(.black)
            .cornerRadius(12)
            .foregroundStyle(.shadow(.drop(color: .black, radius: 12)))
    }
}
