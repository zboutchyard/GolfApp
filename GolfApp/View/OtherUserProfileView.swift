//
//  OtherUserProfileView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/5/23.
//

import SwiftUI

struct OtherUserProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel
    @State var otherUser: OtherUser
    @State var user: User
    @ObservedObject var msgViewModel: MessageViewModel
    @State var isChatViewTriggered: Bool = false
    @State var chatId: String?
    @State var isLoading: Bool = true
    @State private var isInlineTitle = false
    @State var shouldShowMoreOptionsView: Bool = false

    var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        Image("golf-background")
                            .resizable()
                            .ignoresSafeArea()
                            .frame(maxHeight: 300)
                        Spacer()
                        if let data = otherUser.profilePicData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 125, height: 200)
                                .clipShape(Circle())
                                .background {
                                    Circle().fill(Color("AppGray"))
                                }
                                .foregroundStyle(.whiteOrDark)
                        } else {
                            ProfileImage(imageState: .empty)
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 125, height: 200)
                                .background {
                                    Circle().fill(Color("AppGray"))
                                }
                                .padding(22)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
                        } else if (user.friendsList?.contains(otherUser.id)) == true {
                            Text("Friend")
                                .padding()
                        } else {
                            Button(action: {
                                // TODO: implement add friend function here
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
                        .tint(.green)
                        .padding()
                        Spacer()
                    }
                    ProfileInfoView(
                        authViewModel: authViewModel,
                        notificationViewModel: notificationViewModel,
                        msgViewModel: msgViewModel,
                        otherUser: otherUser,
                        isOtherUserProfile: true, shouldShowMoreOptionsView: false)
                    .background(Color.whiteOrDark)
                    
                }
                .background(Color.whiteOrDark)
                
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(otherUser.firstName) \(otherUser.lastName)")
                        .opacity(isInlineTitle ? 1 : 0)
                        .font(.headline)
                }
            }
            .backButtonToolbar()
            .navigationDestination(isPresented: $isChatViewTriggered) {
                if let chatId = chatId {
                    ChatView(msgViewModel: msgViewModel, chatId: chatId, otherUser: otherUser)
                } else {
                    NewChatView(msgViewModel: msgViewModel, otherUser: otherUser, isPresented: .constant(true))
                }
            }
            .background(Color.whiteOrDark)
    }
}

// #Preview {
//    OtherUserProfileView()
// }
