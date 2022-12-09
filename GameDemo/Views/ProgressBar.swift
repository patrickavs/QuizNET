//
//  ProgressBar.swift
//  GameDemo
//
//  Created by Patrick Alves on 28.09.22.
//

import SwiftUI

struct ProgressBar: View {
    @ObservedObject var vm: QuestionVM
    var body: some View {
        HStack {
            /*Rectangle()
                .frame(maxWidth: 350, maxHeight: 8)
                .foregroundColor(.black.opacity(0.2))
                .cornerRadius(10)
            
            Rectangle()
                .frame(width: progress, height: 8)
                .foregroundColor(.black)
                .cornerRadius(10)
            
            Rectangle()
                .frame(width: 370, height: 50)
                .foregroundColor(.black.opacity(0.085))
                .cornerRadius(10)
                .padding(.leading, -10)*/
            
            ForEach(0..<(Int(vm.amount)!), id: \.self) { _ in
                Circle()
                    .foregroundColor(.white)
                    .padding(-3)
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(vm: QuestionVM())
    }
}
