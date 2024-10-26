//
//  NewChatView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/21/23.
//

import SwiftUI
import FirebaseAuth

struct NewChatView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var msgViewModel: MessageViewModel
    @State private var message: String = ""
    @State var otherUser: OtherUser?
    @State var messages: [Message] = []
    @State var chatId: String?
    @State private var showTime: Bool = false
    @Binding var isPresented: Bool

    var body: some View {
            VStack {
                TopRow(otherUser: otherUser!)
                    .background(Color("Green"))
                ScrollViewReader { _ in
                    ScrollView {
                        ForEach(msgViewModel.messages, id: \.self) { message in
                            let received: Bool = message.sender == Auth.auth().currentUser?.uid ? false : true

                            VStack(alignment: received ? .leading : .trailing) {
                                HStack {
                                    Text(message.text ?? "")
                                        .padding()
                                        .background(received ? Color("AppGray") : Color.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                }
                                .frame(maxWidth: 300, alignment: received ? .leading : .trailing)
                                .onTapGesture {
                                    showTime.toggle()
                                }
                                if showTime {
                                    Text("\(message.timestamp!.formatted(.dateTime.hour().minute()))")
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                        .padding(received ? .leading : .trailing, 25)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: received ? .leading : .trailing)
                            .padding(received ? .leading : .trailing)
                            .padding(.horizontal, 10)
                        }
                    }
                }
               
            }
//            .padding(.top, 10)
            .background(colorScheme == .dark ? Color("DarkGray") : .white)
            .cornerRadius(30, corners: [.topLeft, .topRight])
        
        Divider()
        HStack {
            CustomTextField(placeholder: Text("...type something").foregroundStyle(.black), text: $message)
            Button(action: {
                    if let otherUser {
                        msgViewModel.createChatAndSendMessage(text: message, otherUser: otherUser)
                        msgViewModel.fetchChat(chatId: msgViewModel.chatId) { _ in
                            
                        }
                        message = ""
                    }
                    
                isPresented = false
                
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

// #Preview {
//    NewChatView()
// }
