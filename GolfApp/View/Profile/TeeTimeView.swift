//
//  TeeTimeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/22/23.
//

import SwiftUI

struct TeeTimeView: View {
    var body: some View {
        ScrollView {
            VStack{
                Text("Currently Under Construction")
                    .background(Color.yellow)
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
            }
            
            
            
        }
        .background(Color.yellow)
    }
}

#Preview {
    TeeTimeView()
}
