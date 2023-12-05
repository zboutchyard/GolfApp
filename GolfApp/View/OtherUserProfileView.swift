//
//  OtherUserProfileView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/5/23.
//

import SwiftUI

struct OtherUserProfileView: View {
    @State var otherUser: OtherUser
    var body: some View {
        ScrollView {
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
                    Spacer()
                    Text("\(otherUser.firstName) \(otherUser.lastName)")
                        .fontWeight(.light)
                        .kerning(1.2)
                        .padding(.leading)
                        .padding()
                        .lineLimit(1)
                    Spacer()
                    
                }
                .background(.gray)
                HStack {
                    Spacer()
                    Button(action: {}, label: {
                        Text("Add friend")
                    })
                    .buttonStyle(.borderedProminent)
                    .padding()
                    Button(action: {}, label: {
                        Text("Message")
                    })
                    .buttonStyle(.borderedProminent)
                    .padding()
                    Spacer()
                }
                ProfileInfoView(otherUser: otherUser, isOtherUserProfile: true)
            }
        }
        
    }
}

//#Preview {
//    OtherUserProfileView()
//}
