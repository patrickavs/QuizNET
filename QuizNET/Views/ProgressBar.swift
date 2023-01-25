//
//  ProgressBar.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.09.22.
//

import SwiftUI

/// Struct to define how the Progressbar looks like
struct ProgressBar: View {
    @ObservedObject var vm: QuestionVM
    var body: some View {
        ZStack(alignment: .leading) {
             Rectangle()
                .frame(width: vm.progress, height: 8)
                .foregroundColor(.black)
                .cornerRadius(10)
                .animation(.easeOut, value: vm.progress)
             
             Rectangle()
                .fill(.black.opacity(0.075))
                .frame(width: 350, height: 8)
                .cornerRadius(10)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(vm: QuestionVM())
    }
}
