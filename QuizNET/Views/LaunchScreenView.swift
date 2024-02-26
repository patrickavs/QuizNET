//
//  LaunchScreenView.swift
//  LaunchScreenExmpl
//
//  Created by Patrick Alves on 09.02.23.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenVM

    @State private var firstAnimation = false
    @State private var secondAnimation = false
    @State private var startFadeoutAnimation = false
    
    @ViewBuilder
    private var image: some View {  
        Image(uiImage: UIImage(named: "AppIcon")!)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
    
    @ViewBuilder
    private var backgroundColor: some View {
        Color.black.ignoresSafeArea()
    }
    
    var body: some View {
        ZStack {
            backgroundColor
            image
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(LaunchScreenVM())
    }
}

