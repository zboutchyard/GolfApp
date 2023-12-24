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
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @ObservedObject var msgViewModel: MessageViewModel = MessageViewModel()
    @State private var prts: [String]?
    @State private var isLoading: Bool = false
    @State private var isAddMessageButtonClicked = false
    @State private var selectedChatId: String?
    var body: some View {
        VStack {
            if isLoading {
                LoadingView()
            } else {
                VStack {
                    HStack {
                        Text("Messages")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                        Button(action: {
                            isAddMessageButtonClicked = true
                        }) {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 20, height: 20)
                        } .padding(.trailing)
                    }
                    Divider()
                    if let chats = authViewModel.user?.chats, chats.count > 0 {
                        List {
                            ForEach((chats), id: \.self){  chat in
                                AllChatCellView(selectedChatId: $selectedChatId, chatId: chat)
                                    .frame(maxWidth: .infinity)
                                
                                
                            }
                            .onDelete(perform: deleteItem)
                            

                        }
                    }
                    else {
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
        .sheet(isPresented: $isAddMessageButtonClicked) {
            if let user = authViewModel.user {
                NewMessageView(user: user, isPresented: $isAddMessageButtonClicked)
            }
        }
        .toolbar {
            EditButton()
        }
       
        
        
    }
    
    func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            guard let chatId = authViewModel.user?.chats?[index] else { return }
            msgViewModel.deleteUserChat(chatId: chatId)
        }
        // Update the local state to reflect the deletion
        authViewModel.user?.chats?.remove(atOffsets: offsets)
    }
}

#Preview {
    AllChatsView()
}
