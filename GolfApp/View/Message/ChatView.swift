//
//  ChatView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI
import FirebaseFirestore

struct ChatView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var msgViewModel: MessageViewModel
    @State var chatId: String
    @State var otherUser: OtherUser
    @State var messages: [Message] = []
    
    var body: some View {
        VStack {
                VStack {
                    TopRow(otherUser: otherUser)
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .background(Color("Green"))
                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(messages, id: \.text) { message in
                                MessageBubble(message: Message( sender: message.sender, text: message.text, timestamp: message.timestamp))
                            }
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .onAppear {
                            withAnimation {
                                proxy.scrollTo(messages.last?.text, anchor: .bottom)
                            }
                        }
                        .onChange(of: msgViewModel.lastMessage) {
                            if msgViewModel.lastMessage?.text == messages.last?.text {
                                withAnimation {
                                    proxy.scrollTo(messages.last?.text, anchor: .bottom)
                                }
                            } else {
                                
                            }
                        }
                    }
                    .padding(.top, 10)
                    .background(colorScheme == .dark ? Color("DarkGray") : .white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                }
                .background(Color("Green").ignoresSafeArea())
            
            Divider()
            MessageField(chatId: chatId, messageViewmodel: msgViewModel, otherUser: otherUser)
                    .environmentObject(msgViewModel)
        } .onAppear {
            msgViewModel.fetchChat(chatId: chatId) { fetchedChat in
                messages = fetchedChat?.messages ?? []
            }
        }
    }
    private func hideKeyboard() {
           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
       }
}
