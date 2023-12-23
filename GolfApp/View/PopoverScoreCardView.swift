//
//  PopoverScoreCardView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/22/23.
//

import SwiftUI

struct PopoverScoreCardView: View {
    var body: some View {
                VStack {
                    Image("golf_swing_popover")
                        .resizable()
                    Spacer()
                    VStack(spacing: 0) {
                        RoundedCorner(radius: 70.0, corners: [.topRight, .topLeft])
                            .overlay(){
                                Text("Share your current round with others in your feed, allowing them to comment and react in real time while you're playing")
                                    .foregroundStyle(.white)
                                    .padding(30)
                                    .font(.title3)
                            }
                            .foregroundStyle(.whiteOrDark)
                            .frame(height: 300, alignment: .bottom)
                            
                        
                            .background(.whiteOrDark)

                            
                            
                        
                    }
                    .frame(height: 300, alignment: .bottom)
                   

                    
                }
                
            
            .background(.whiteOrDark)
        
    }
}

#Preview {
    PopoverScoreCardView()
}
