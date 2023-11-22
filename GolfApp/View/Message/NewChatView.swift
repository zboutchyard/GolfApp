//
//  NewChatView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/21/23.
//

import SwiftUI
import FirebaseAuth

struct NewChatView: View {
    @StateObject var msgViewModel: MessageViewModel = MessageViewModel()
    @State private var message: String = ""
    @State var otherUser: OtherUser?
    @State var messages: [Message] = []
    @State var chatId: String?
    @State private var showTime: Bool = false
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            VStack {
                TopRow(otherUser: otherUser!)
                //                    //                        .onTapGesture {
                //                    //                            hideKeyboard()
                //                    //                        }
                    .background(Color("Green"))
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(msgViewModel.messages, id: \.self) { message in
                            let received: Bool = message.sender == Auth.auth().currentUser?.uid ? false : true

                            VStack(alignment: received ? .leading : .trailing){
                                HStack {
                                    Text(message.text ?? "")
                                        .padding()
                                        .background(received ? Color("Gray") : Color.blue)
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
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
        }
        Divider()
        HStack {
            CustomTextField(placeholder: Text("...type something"), text: $message)
            Button(action: {
                    if let otherUser {
                        msgViewModel.createChatAndSendMessage(text: message, otherUserId: otherUser.id)
                        msgViewModel.fetchChat(chatId: msgViewModel.chatId) { fetchedChat in
                            
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
        .background(Color("Gray"))
        .cornerRadius(50)
        .padding()
    }
}

//#Preview {
//    NewChatView()
//}
