//
//  TeeTimeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/22/23.
//

import SwiftUI

struct TeeTimeView: View {
    var body: some View {
            VStack(alignment: .center){
                
                Text("Currently Under Construction")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                    Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .padding(30)
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow)
        .opacity(0.2)
    }
}

#Preview {
    TeeTimeView()
}
