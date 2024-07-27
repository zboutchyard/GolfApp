//
//  NewMessageView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/21/23.
//

import SwiftUI

struct NewMessageView: View {
    @State var user: User
    @StateObject var authViewModel: AuthViewModel
    @StateObject var msgViewModel: MessageViewModel
    @StateObject var notificationViewModel: NotificationViewModel
    @State var otherUsers: [OtherUser] = []
    @Binding var isPresented: Bool
    @State var isChatViewTriggered: Bool = false
    @State var otherUser: OtherUser?
    @State var chatId: String?
    @State var isAddFriendClicked: Bool = false
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            VStack {
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
                    if !otherUsers.isEmpty {
                        ForEach(otherUsers, id: \.firstName) { friend in
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
                    } else {
                        Spacer()
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 200)
                        Text("In order to start a chat, you'll need a friend. Click below to get started")
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            isAddFriendClicked = true
                        }, label: {
                            Text("Search")
                        })
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                        
                }
                .navigationDestination(isPresented: $isAddFriendClicked) {
                    SearchDetailView(
                        authViewModel: authViewModel,
                        msgViewModel: msgViewModel,
                        searchText: $searchText,
                        user: user,
                        isAddFriendView: .constant(true), 
                        notificationViewModel: notificationViewModel)
                            .toolbar(content: {
                                ToolbarItem(placement: .principal) {
                                    TextField("search users", text: $searchText)
                                        .padding(.leading)
                                        .padding(4)
                                        .font(.system(size: 20))
                                        .background(RoundedRectangle(cornerRadius: 30).stroke(Color.heading, lineWidth: .init(1.0)))
                                }
                            })
                    
                }
                .navigationDestination(isPresented: $isChatViewTriggered, destination: {
                    if let chatId = chatId {
                        if let otherUser = otherUser {
                            ChatView(msgViewModel: msgViewModel, chatId: chatId, otherUser: otherUser)
                        }
                    } else {
                        NewChatView(msgViewModel: msgViewModel, otherUser: otherUser, isPresented: .constant(true))
                    }
                })
            }
        }
         .onAppear {
                getOtherUserInfo(friendsList: user.friendsList ?? [])
        }
    }
    
    func getOtherUserInfo(friendsList: [String]) {
        for friend in friendsList {
            authViewModel.fetchOtherUserFromFirebase(id: friend) { friend in
                if let friend = friend {
                    otherUsers.append(friend)
                }
            }
        }
    }
}
