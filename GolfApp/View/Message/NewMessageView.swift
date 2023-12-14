//
//  NewMessageView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/21/23.
//

import SwiftUI

struct NewMessageView: View {
    @State var user: User
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @StateObject var msgViewModel: MessageViewModel = MessageViewModel()
    @State var otherUsers: [OtherUser] = []
    @Binding var isPresented: Bool
    @State var isChatViewTriggered: Bool = false
    @State var otherUser: OtherUser?
    @State var chatId: String?


    var body: some View {
        NavigationStack {
            VStack() {
                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .padding(.leading)
                    Spacer()
                    Text("New Message")
                        .font(.title3).bold()
                        .frame( alignment: .center)
                        .padding()
                    Spacer()
                    Spacer()
                }
                Divider()
                ScrollView {
                        ForEach(otherUsers, id: \.firstName){ friend in
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(.whiteOrDark)
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                        .background {
                                            Circle().fill(Color("AppGray"))
                                        }
                                    VStack {
                                        Text("\(friend.firstName) \(friend.lastName)")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    Spacer()
                                } .onTapGesture {
                                    if let chats = user.chats {
                                        for chat in chats {
                                            msgViewModel.fetchChat(chatId: chat) { fetchedChat in
                                                if fetchedChat?.participants?.contains(otherUser?.id ?? "") == true {
                                                    chatId = chat
                                                    isChatViewTriggered = true
                                                }
                                            }
                                        }
                                        isChatViewTriggered = true
                                    }
                                    otherUser = friend
                                    isChatViewTriggered = true
                                }
                                Divider()
                                
                        }
                }
                .navigationDestination(isPresented: $isChatViewTriggered, destination: {
                    if let chatId = chatId {
                        ChatView(chatId: chatId, otherUser: otherUser)
                    } else {
                        NewChatView(otherUser: otherUser, isPresented: .constant(true))
                    }
                })
            }
        }
         .onAppear() {
                getOtherUserInfo(friendsList: user.friendsList ?? [])
        }
    }
    
    func getOtherUserInfo(friendsList: [String]){
        for friend in friendsList {
            authViewModel.fetchOtherUserFromFirebase(id: friend){ friend in
                if let friend = friend {
                    otherUsers.append(friend)
                }
            }
        }
    }
}

//#Preview {
//    NewMessageView()
//}
