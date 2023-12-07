//
//  OtherUserProfileView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/5/23.
//

import SwiftUI

struct OtherUserProfileView: View {
    @State var otherUser: OtherUser
    @State var user: User?
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
                    if user?.sentRequests?.contains(where: { $0.user == otherUser.id }) == true {
                        Text("Pending approval")
                            .padding()
                    } else if ((user?.friendsList?.contains(otherUser.id)) == true) {
                        Text("Friend")
                            .padding()
                    } else {
                        Button(action: {}, label: {
                            Text("Add friend")
                        })
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                   
                    
                    Button(action: {}, label: {
                        Text("Message")
                    })
                    .buttonStyle(.borderedProminent)
                    .padding()
                    Spacer()
                }
                ProfileInfoView(otherUser: otherUser, isOtherUserProfile: true)
                    .background(Color.whiteOrDark)
            }
            .background(Color.whiteOrDark)
        }
        
    }
}

//#Preview {
//    OtherUserProfileView()
//}
