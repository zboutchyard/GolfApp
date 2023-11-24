//
//  ProfileHeadingView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct ProfileHeadingView: View {
    @Binding var isEditButtonClicked: Bool
    @Binding var isOtherViewTriggered: Bool
    var body: some View {
        VStack (spacing: 0){
            VStack {
                ProfileImage(imageState: .empty)
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 125, height: 125)
                    .background {
                        Circle().fill(Color("Gray"))
                    }
                    .padding(22)
            }
            .frame(maxWidth: .infinity)
            .background(Image("golf-background").resizable().ignoresSafeArea())
            HStack {
                Text("Zachary Boutchyard")
                    .fontWeight(.light)
                    .kerning(1.2)
                    .padding(.leading)
                    .padding()
                    .lineLimit(1)
                Spacer()
                if !isEditButtonClicked && !isOtherViewTriggered {
                    Button(action: {
                        isEditButtonClicked.toggle()
                    }, label: {
                        Text("Update profile")
                        
                    })
                    .padding(.trailing)
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                if isEditButtonClicked {
                    Button(action: {
                        isEditButtonClicked.toggle()
                    }, label: {
                        Text("Submit")
                        
                    })
                    .padding(.trailing)
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                
            }
            .background(.gray)
        }    }
}

#Preview {
    ProfileHeadingView(isEditButtonClicked: .constant(false), isOtherViewTriggered: .constant(false))
}
