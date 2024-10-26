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
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var msgViewModel: MessageViewModel
    @Binding var selectedChatId: String?
    @State var otherUser: OtherUser
    @State var isLoading: Bool = true
    @State var image: UIImage?
    let chatId: String
    @State var isMessageClicked = false
    
    var body: some View {
        VStack {
            NavigationStack {
                    HStack {
                        if let data = otherUser.profilePicData, let uiImage = UIImage(data: data) {
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
                            Text("\(otherUser.firstName) \(otherUser.lastName)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                if let message = msgViewModel.lastMessage {
                                    Text(message.text ?? "")
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
        .navigationDestination(isPresented: $isMessageClicked) {
            ChatView(msgViewModel: msgViewModel, chatId: chatId, otherUser: otherUser)
        }
    }
}
