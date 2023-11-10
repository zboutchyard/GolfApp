//
//  SwiftUIView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI

struct MessageBubble: View {
    var message: Message
    @State private var showTime: Bool = false
    var body: some View {
        VStack(alignment: message.received ? .leading : .trailing){
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.received ? Color("Gray") : Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            .frame(maxWidth: 300, alignment: message.received ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                    .padding(message.received ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
        .padding(message.received ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

#Preview {
    MessageBubble(message: Message(id: "12345", text: "Hello user, this is a pretty cool chat app that I've made with SwiftUI.. How neat!", received: true, timestamp: Date()))
}
