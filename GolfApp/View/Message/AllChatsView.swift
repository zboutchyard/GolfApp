//
//  AllChatsView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct AllChatsView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var msgViewModel: MessageViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel
    @State private var prts: [String]?
    @State private var isLoading: Bool = true
    @State private var isAddMessageButtonClicked = false
    @State private var selectedChatId: String?
    @State private var otherUser: OtherUser?
    var body: some View {
        VStack {
            if isLoading {
                LoadingView()
            } else {
                VStack {
                    Divider()
                    if let chats = authViewModel.user?.chats, !chats.isEmpty {
                        List {
                            if let otherUser = otherUser {
                                ForEach((chats), id: \.self) { chat in
                                    AllChatCellView(authViewModel: authViewModel,
                                                    msgViewModel: msgViewModel,
                                                    selectedChatId: $selectedChatId,
                                                    otherUser: otherUser,
                                                    chatId: chat)
                                        .frame(maxWidth: .infinity)
                                }
                                .onDelete(perform: deleteItem)
                            }
                        }
                    } else {
                        Spacer()
                        Image(systemName: "bubble.left.and.exclamationmark.bubble.right")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 200)
                        Text("You don't have any messages")
                        Button(action: {
                            isAddMessageButtonClicked = true
                        }, label: {
                            Text("Start a conversation")
                        })
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden()
        .backButtonToolbar()
        .onAppear {
            Task {
                fetchData()
            }
        }
        .sheet(isPresented: $isAddMessageButtonClicked) {
            if let user = authViewModel.user {
                NewMessageView(user: user,
                               authViewModel: authViewModel,
                               msgViewModel: msgViewModel,
                               notificationViewModel: notificationViewModel,
                               isPresented: $isAddMessageButtonClicked)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Messages")
                    .font(.title)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isAddMessageButtonClicked = true}) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
    
    func fetchData() {
        getChat()
    }
    
    func getChat() {
        if let chats = authViewModel.user?.chats {
            for chat in chats {
                msgViewModel.fetchChat(chatId: chat) { _ in
                    if let chat = msgViewModel.chat {
                        getParticipantName(chatModel: chat)
                    }
                }
            }
        }
        isLoading = false
    }
    
    func getParticipantName(chatModel: Chat) {
        guard let userUid = Auth.auth().currentUser?.uid else {
            return
        }
        let otherParticipants = chatModel.participants!.filter { $0 != userUid }
        if let otherUserId = otherParticipants.first {
            authViewModel.fetchOtherUserFromFirebase(id: otherUserId) { fetchedUser in
                otherUser = fetchedUser
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            guard let chatId = authViewModel.user?.chats?[index] else { return }
            msgViewModel.deleteUserChat(chatId: chatId)
        }
        authViewModel.user?.chats?.remove(atOffsets: offsets)
    }
}
