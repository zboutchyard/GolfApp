//
//  LoadingView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/7/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isBlinking: Bool = true
    var body: some View {
        VStack {
            Image(systemName: "person.text.rectangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.appGray)
                .opacity(0.3)
                .padding()
            Text("Hang tight...")
                .padding()
                .kerning(1.2)
                .fontWeight(.regular)
        }
        .opacity(isBlinking ? 0 : 1)
        .animation(.easeInOut(duration: 2.5).repeatForever(), value: isBlinking)
        .onAppear() {
            self.isBlinking.toggle()
        }
       
            .foregroundStyle(.gray)
        Spacer()
    }
}

#Preview {
    LoadingView()
}
