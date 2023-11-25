//
//  ProfileInfoView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct ProfileInfoView: View {
    @State var user: User
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
                if let bio = user.bio {
                    Text(bio)
                        .fontWeight(.light)
                        .kerning(1.2)
                        .padding()
                        .padding(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                }
            }
            HStack {
                Text("Interests:")
                    .fontWeight(.regular)
                    .kerning(1.2)
                    .padding()
                    .padding(.leading)
                Spacer()
                if let interests = user.interests {
                    Text(interests)
                        .fontWeight(.light)
                        .kerning(1.2)
                        .padding()
                        .padding(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                }
                
            }
            HStack {
                Text("Handicap:")
                    .fontWeight(.regular)
                    .kerning(1.2)
                    .padding()
                    .padding(.leading)
                Spacer()
                if let handicap = user.handicap {
                    Text(String(handicap))
                        .fontWeight(.light)
                        .kerning(1.2)
                        .padding()
                        .padding(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                }
            }
            HStack {
                Text("Home course:")
                    .fontWeight(.regular)
                    .kerning(1.2)
                    .padding()
                    .padding(.leading)
                Spacer()
                if let homeCourse = user.homeCourse {
                    Text(homeCourse)
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
}

#Preview {
    ProfileInfoView(user: User(firstName: "Zack", lastName: "Boutchyard", email: "zackboutchyard@gmail.com", chats: ["123123"], friendsList: ["123123"], bio: "Here is a short bio about a boy who was sitting on the ouch doing nothing but coding for months so he could get maybe a slightly bigger paycheck", handicap: 12, homeCourse: "asheboro municipal"))
}
