//
//  PersonCellView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/24/23.
//

import SwiftUI

struct PersonCellView: View {
    @State var otherUser: OtherUser?
    var body: some View {
        if let otherUser = otherUser {
            HStack {
                Image(systemName: "person.fill")
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .background {
                        Circle().fill(Color("Gray"))
                    }
                VStack {
                    Text("\(otherUser.firstName) \(otherUser.lastName)")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding([.leading, .trailing, .top])
        }
        else {
            HStack {
                Image(systemName: "person.fill")
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .background {
                        Circle().fill(Color("Gray"))
                    }
                VStack {
                    Text("Zack Boutchyard")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("3h")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                }
            }
            .padding([.leading, .trailing, .top])
        }
    }
}

#Preview {
    PersonCellView()
}
