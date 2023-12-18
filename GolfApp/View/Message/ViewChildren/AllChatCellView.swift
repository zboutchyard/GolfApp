//
//  AllChatCellView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/20/23.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct AllChatCellView: View {
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @StateObject var msgViewModel: MessageViewModel = MessageViewModel()
    @Binding var selectedChatId: String?
    @State private var otherUser: OtherUser?
    @State private var chatModel: Chat?
    @State private var isLoading: Bool = true
    @State var image: UIImage?
    let chatId: String
    @State var isMessageClicked = false
    
    var body: some View {
                VStack {
                    NavigationStack {
                        if let user = otherUser {
                            HStack {
                                if let data = user.profilePicData, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .background {
                                                Circle().fill(Color("AppGray"))
                                            }
                                            .foregroundStyle(.whiteOrDark)
                                    } else {
                                    Image(systemName: "person.fill")
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                        .background {
                                            Circle().fill(Color("AppGray"))
                                        }
                                        .foregroundStyle(.whiteOrDark)
                                }
                                VStack {
                                    Text("\(user.firstName) \(user.lastName)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack {
                                        if let message = chatModel?.messages?.last {
                                            Text(message.text!)
                                                .lineLimit(1)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(message.timestamp!.formatted(.dateTime.month(.wide).day()))
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .onTapGesture {
                                isMessageClicked = true
                            }
                            .padding()

                        }
                       
                    }
                    
                    
                    
                    
                }
                .navigationDestination(isPresented: $isMessageClicked) {
                    ChatView(chatId: chatId, otherUser: otherUser, image: image)
               }
               .onAppear() {
                   Task {
                    fetchData()
                   }
               }
    }
    
    
    func fetchData() {
        getAllConversations()
    }
    
    func getAllConversations()  {
        msgViewModel.fetchChat(chatId: self.chatId) { fetchedChat in
            chatModel = fetchedChat
            getParticipantName(chatModel: chatModel!)
        }
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
    
}
//#Preview {
//    AllChatCellView()
//}
