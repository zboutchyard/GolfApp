//
//  ChatBoxView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/10/23.
//

import SwiftUI

struct ChatCardView: View {
    var participant: String?
    var body: some View {
        HStack {
            Circle()
                .overlay {
                    Text("J")
                        .font(.title)
                        .foregroundStyle(.black)
                }
                .foregroundStyle(generateRandomColor())
                .frame(width: 75, height: 75)
            VStack {
                Text("Name of participant")
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("hereh is an example of a message that might be sent")
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Text("Sep 22")
                .font(.caption)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
    func generateRandomColor() -> Color {
        return Color(UIColor(red: CGFloat.random(in: 0...1),
                            green: CGFloat.random(in: 0...1),
                            blue: CGFloat.random(in: 0...1),
                            alpha: 1.0))
    }
}

#Preview {
    ChatCardView()
}
