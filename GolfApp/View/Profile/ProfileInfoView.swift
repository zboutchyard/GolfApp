//
//  ProfileInfoView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct ProfileInfoView: View {
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
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
            HStack(alignment: .top) {
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
            HStack(alignment: .top) {
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
            HStack(alignment: .top) {
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
            HStack(alignment: .top) {
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
            Divider()
            VStack {
                Text("Your Posts")
                    .fontWeight(.semibold)
                    .kerning(1.2)
                    .padding()
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                ForEach(authViewModel.userPosts.sorted(by: { $0.timeStamp > $1.timeStamp}), id: \.self) { post in
                    PostView(post: post)
                    Divider()
                }
            }
            .onAppear(){
                print(user.posts ?? "no user posts found")
                if let posts = user.posts {
                    authViewModel.fetchAllPostsInUserObject(postIds: posts)
                }
            }
        }
    }
}

#Preview {
    ProfileInfoView(user: User(firstName: "Zack", lastName: "Boutchyard", email: "zackboutchyard@gmail.com", chats: ["123123"], friendsList: ["123123"], bio: "Here is a short bio about a boy who was sitting on the ouch doing nothing but coding for months so he could get maybe a slightly bigger paycheck", handicap: 12, homeCourse: "asheboro municipal"))
}
