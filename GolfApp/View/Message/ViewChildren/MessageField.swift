//
//  MessageField.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI

struct MessageField: View {
    @State private var message: String = ""
    @State var chatId: String?
    @EnvironmentObject var msgViewModel: MessageViewModel
    @ObservedObject var messageViewmodel: MessageViewModel
    @State var isNewMessage: Bool = false
    @State var otherUser: OtherUser?
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("...type something").foregroundStyle(.black), text: $message)
            Button(action: {
                if !isNewMessage {
                    if let chatId = chatId {
                        if let otherUser = otherUser {
                            msgViewModel.sendMessage(chatId: chatId, text: message, otherUser: otherUser)
                            message = ""
                        }
                        
                    }
                } else {
                    if let otherUser {
                        messageViewmodel.createChatAndSendMessage(text: message, otherUser: otherUser)
                        messageViewmodel.fetchChat(chatId: msgViewModel.chatId) { _ in
                            
                        }
                        message = ""
                    }
                }
                
            }, label: {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color("Green"))
                    .cornerRadius(50)
            })
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color("AppGray"))
        .cornerRadius(50)
        .padding()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> Void = { _ in }
    var commit: () -> Void = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
