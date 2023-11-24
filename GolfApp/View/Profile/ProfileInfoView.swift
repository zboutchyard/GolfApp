//
//  ProfileInfoView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct ProfileInfoView: View {
    var body: some View {
        Divider()
        Text("Information")
            .fontWeight(.semibold)
            .kerning(1.2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .padding()
        Divider()
            .padding(.horizontal)
        Section {
            HStack {
                Text("About me:")
                    .fontWeight(.regular)
                    .kerning(1.2)
                    .padding()
                    .padding(.leading)
                Spacer()
                Text("here is a bio written from the user that describes something unique about them, it has to be less than 200 chars")
                    .fontWeight(.light)
                    .kerning(1.2)
                    .padding()
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Interests:")
                    .fontWeight(.regular)
                    .kerning(1.2)
                    .padding()
                    .padding(.leading)
                Spacer()
                Text("Volleyball, Tennis, Stuff, Things, Things I like to Do")
                    .fontWeight(.light)
                    .kerning(1.2)
                    .padding()
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Handicap:")
                    .fontWeight(.regular)
                    .kerning(1.2)
                    .padding()
                    .padding(.leading)
                Spacer()
                Text("18")
                    .fontWeight(.light)
                    .kerning(1.2)
                    .padding()
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Home course:")
                    .fontWeight(.regular)
                    .kerning(1.2)
                    .padding()
                    .padding(.leading)
                Spacer()
                Text("Asheboro Municipal")
                    .fontWeight(.light)
                    .kerning(1.2)
                    .padding()
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

#Preview {
    ProfileInfoView()
}
