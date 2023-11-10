//
//  ChatView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI

struct ChatView: View {
    var messageArray = [
        "Hey, whats up?",
        "Hey, not much just hanging out at the house",
        "Oh nice, you want to meet up tonight?",
        "Yeah sure, where you thinking?",
        "Let's go grab a coffee at the shop down the road",
        "Sounds good, I'll be up there shortly"
    ]
    var body: some View {
        VStack {
            VStack {
                TopRow()
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .background(Color("Green"))
                ScrollView {
                    ForEach(messageArray, id: \.self) { message in
                        MessageBubble(message: Message(id: "12345", text: message, received: true, timestamp: Date()))
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
            .background(Color("Green").ignoresSafeArea())
            
            Divider()
            MessageField()
        }
    }
    private func hideKeyboard() {
           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
       }
}

#Preview {
    ChatView()
}
