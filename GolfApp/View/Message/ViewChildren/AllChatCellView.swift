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
    let randomColor = Color(UIColor(red: CGFloat.random(in: 0...1),
                                    green: CGFloat.random(in: 0...1),
                                    blue: CGFloat.random(in: 0...1),
                                    alpha: 1.0))
    let chatId: String
    @State var isMessageClicked = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if !isLoading {
                    if let otherUser = otherUser {
                        NavigationStack {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.whiteOrDark)
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                                    .background {
                                        Circle().fill(Color("Gray"))
                                    }
                                VStack {
                                    Text("\(otherUser.firstName) \(otherUser.lastName)")
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
            }.onAppear() {
                fetchData()
            }
            if isLoading {
                ProgressView("Fetching your profile information")
                    .progressViewStyle(.circular)
                    .padding()
            }
        } .navigationDestination(isPresented: $isMessageClicked) {
            if let otherUser = otherUser {
                ChatView(chatId: chatId, otherUser: otherUser)
                
            }
        }
    }
    
    func generateRandomAccessibleColor() -> Color {
        let minimumLuminance: CGFloat = 0.3
        let maximumLuminance: CGFloat = 0.7

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0

        repeat {
            red = CGFloat.random(in: 0...1)
            green = CGFloat.random(in: 0...1)
            blue = CGFloat.random(in: 0...1)
        } while !isColorAccessible(red: red, green: green, blue: blue, minimumLuminance: minimumLuminance, maximumLuminance: maximumLuminance)

        return Color(red: red, green: green, blue: blue)
    }

    func isColorAccessible(red: CGFloat, green: CGFloat, blue: CGFloat, minimumLuminance: CGFloat, maximumLuminance: CGFloat) -> Bool {
        let luminance = (0.2126 * red) + (0.7152 * green) + (0.0722 * blue)
        return luminance >= minimumLuminance && luminance <= maximumLuminance
    }

    
    func fetchData() {
        getAllConversations()
        isLoading = false
        selectedChatId = chatId
    }
    
    func getAllConversations() {
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
