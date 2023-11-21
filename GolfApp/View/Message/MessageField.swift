//
//  MessageField.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI

struct MessageField: View {
    @State private var message: String = ""
    @State var chatId: String
    @EnvironmentObject var msgViewModel: MessageViewModel
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("...type something"), text: $message)
            Button(action: {
                msgViewModel.sendMessage(chatId: chatId, text: message)
                message = ""
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

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
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
