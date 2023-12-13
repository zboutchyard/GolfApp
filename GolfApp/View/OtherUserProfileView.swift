//
//  OtherUserProfileView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/5/23.
//

import SwiftUI

struct OtherUserProfileView: View {
    @State var otherUser: OtherUser
    @State var user: User
    @ObservedObject var msgViewModel: MessageViewModel = MessageViewModel()
    @State var isChatViewTriggered: Bool = false
    @State var chatId: String?
    var body: some View {
        ScrollView {
            VStack (spacing: 0){
                VStack {
                    ProfileImage(imageState: .empty)
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 125, height: 125)
                        .background {
                            Circle().fill(Color("AppGray"))
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
                    if user.sentRequests?.contains(where: { $0.user == otherUser.id }) == true {
                        Text("Pending approval")
                            .padding()
                    } else if ((user.friendsList?.contains(otherUser.id)) == true) {
                        Text("Friend")
                            .padding()
                    } else {
                        Button(action: {
                            //TODO: implement add friend function here
                        }, label: {
                            Text("Add friend")
                        })
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                   
                    
                    Button(action: {
                        if let chats = user.chats {
                            for chat in chats {
                                msgViewModel.fetchChat(chatId: chat) { fetchedChat in
                                    if fetchedChat?.participants?.contains(otherUser.id) == true {
                                        chatId = chat
                                        isChatViewTriggered = true
                                    }
                                }
                            }
                            isChatViewTriggered = true
                        }
                    }, label: {
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
        .navigationDestination(isPresented: $isChatViewTriggered) {
            if let chatId = chatId {
                ChatView(chatId: chatId, otherUser: otherUser)
            } else {
                NewChatView(otherUser: otherUser, isPresented: .constant(true))
            }
        }
    }
}

//#Preview {
//    OtherUserProfileView()
//}
