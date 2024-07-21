//
//  TopRow.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI

struct TopRow: View {
    @State var otherUser: OtherUser
    var photoUrl = URL(string: "https://images.unsplash.com/photo-1629747490241-624f07d70e1e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cG9ydHJhaXRzfGVufDB8fDB8fHww")
    @State var image: UIImage?
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .trailing) {
                Text(otherUser.firstName)
                    .font(.title).bold()
                    .foregroundStyle(.heading)
                Text("Online")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            if let data = otherUser.profilePicData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .background {
                        Circle().fill(Color("AppGray"))
                    }
                    .padding(.trailing, 10)
                    .foregroundStyle(.whiteOrDark)
            } else {
                Image(systemName: "person.fill")
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .background {
                        Circle().fill(Color("AppGray"))
                    }
                    .padding(.trailing, 10)
                    .foregroundStyle(.whiteOrDark)
            }
        }
    }
}
