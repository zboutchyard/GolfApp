//
//  ProfileInfoView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct ProfileInfoView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject var notificationViewModel: NotificationViewModel
    @StateObject var msgViewModel: MessageViewModel
    @State var user: User?
    @State var otherUser: OtherUser?
    @State var isOtherUserProfile: Bool = false
    @State var isLoading: Bool = true
    var body: some View {
        VStack {
            if !isOtherUserProfile {
                VStack {
                    VStack {
                        VStack {
                            Text("Information")
                                .fontWeight(.semibold)
                                .kerning(1.2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .padding(.top)
                            Divider()
                        }
                        .background(Color.appGray)
                        
                        HStack(alignment: .top) {
                            Text("About me:")
                                .fontWeight(.regular)
                                .kerning(1.2)
                                .padding()
                                .padding(.leading)
                            Spacer()
                            if let bio = user?.bio {
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
                            if let interests = user?.interests {
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
                            if let handicap = user?.handicap {
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
                            if let homeCourse = user?.homeCourse {
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
                    .background(Color.whiteOrDark)
                    .padding(.top, 7.5)
                    
                    if !authViewModel.userPosts.isEmpty {
                        VStack {
                            VStack {
                                Text("Posts")
                                    .fontWeight(.semibold)
                                    .kerning(1.2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .padding(.top)
                                Divider()
                            }
                            .background(Color.appGray)
                            VStack {
                                if let posts = authViewModel.posts {
                                    ForEach(posts.indices, id: \.self) { index in
                                        let post = posts[index]
                                        if let user = authViewModel.user, let otherUser = authViewModel.postOtherUsers {
                                            PostsWithAdsView(
                                                authViewModel: authViewModel,
                                                notificationViewModel: notificationViewModel,
                                                msgViewModel: msgViewModel,
                                                user: user,
                                                post: post,
                                                otherUser: otherUser[post.user], index: index)
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 2)
                            .background(Color.blackOrGray)
                            
                        }
                        .background(Color.whiteOrDark)
                    }
                    
                }
                .background(Color.whiteOrBlack)
            } else {
                    VStack {
                        VStack {
                            VStack {
                                Text("Information")
                                    .fontWeight(.semibold)
                                    .kerning(1.2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .padding(.top)
                                Divider()
                            }
                            .background(Color.appGray)
                            
                            HStack(alignment: .top) {
                                Text("About me:")
                                    .fontWeight(.regular)
                                    .kerning(1.2)
                                    .padding()
                                    .padding(.leading)
                                Spacer()
                                if let bio = otherUser?.bio {
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
                                if let interests = otherUser?.interests {
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
                                if let handicap = otherUser?.handicap {
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
                                if let homeCourse = otherUser?.homeCourse {
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
                        .background(Color.whiteOrDark)
                        .padding(.top, 7.5)
                        
                        if !authViewModel.userPosts.isEmpty {
                            VStack {
                                VStack {
                                    Text("Posts")
                                        .fontWeight(.semibold)
                                        .kerning(1.2)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                        .padding(.top)
                                    Divider()
                                }
                                .background(Color.appGray)
                                VStack {
                                    ForEach(authViewModel.userPosts.sorted(by: { $0.timeStamp > $1.timeStamp}), id: \.self) { post in
                                        PostView(authViewModel: authViewModel,
                                                 notificationViewModel: notificationViewModel,
                                                 msgViewModel: msgViewModel,
                                                 post: post,
                                                 otherUser: otherUser)
                                    }
                                    .padding(.bottom, 2)
                                }
                                .background(Color.whiteOrBlack)
                                
                            }
                            .background(Color.whiteOrDark)
                        }
                        
                    }
                    .background(Color.whiteOrBlack)
                    .onAppear {
                        Task {
                           await authViewModel.fetchAllPostsInUserObject(postIds: otherUser?.posts ?? [])
                        }
                    }
                
            }
        }
        
    }
}
// #Preview {
//    ProfileInfoView(user: User(firstName: "Zack", lastName: "Boutchyard", email: "zackboutchyard@gmail.com", chats: ["123123"], friendsList: ["123123"], bio: "Here is a short bio about a boy who was sitting on the ouch doing nothing but coding for months so he could get maybe a slightly bigger paycheck", handicap: 12, homeCourse: "asheboro municipal"), isLoading: false)
// }
