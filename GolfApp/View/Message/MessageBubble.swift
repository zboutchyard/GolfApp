//
//  SwiftUIView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI
import FirebaseAuth

struct MessageBubble: View {
    var message: Message
    @State private var showTime: Bool = false
    var body: some View {
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

