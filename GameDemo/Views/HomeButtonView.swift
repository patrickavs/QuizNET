//
//  HomeButtonView.swift
//  GameDemo
//
//  Created by Patrick Alves on 26.09.22.
//

import SwiftUI

struct HomeButtonView: View {
    var body: some View {
        Text("Play")
            .startButton()
    }
}

struct HomeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HomeButtonView()
    }
}
