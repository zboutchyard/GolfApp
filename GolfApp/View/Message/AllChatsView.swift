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
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @StateObject var msgViewModel: MessageViewModel = MessageViewModel()
    @State private var user: User?
    @State private var prts: [String]?
    @State private var isLoading: Bool = true
    @State private var isAddMessageButtonClicked = false
    @State private var selectedChatId: String?
    var body: some View {
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
                    List {
                        if let chats = user?.chats {
                                ForEach((chats), id: \.self){  chat in
                                    AllChatCellView(selectedChatId: $selectedChatId, chatId: chat)
                                        .frame(maxWidth: .infinity)
                                }
                                .onDelete(perform: deleteItem)
                            
                        }
                    }
                    .sheet(isPresented: $isAddMessageButtonClicked) {
                        if let user = user {
                            NewMessageView(user: user, isPresented: $isAddMessageButtonClicked)
                        }
                    }
            } 
            .toolbar {
                EditButton()
            }
            .onAppear(){
                getUserData()
            }
            .onChange(of: isAddMessageButtonClicked) {
                getUserData()
            }
    }
    func getUserData() {
        authViewModel.fetchUserDataFromFirebase { fetchedUser in
            user = fetchedUser
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        if selectedChatId != nil {
            msgViewModel.deleteUserChat(chatId: selectedChatId!)
        }
    }
}

#Preview {
    AllChatsView()
}
