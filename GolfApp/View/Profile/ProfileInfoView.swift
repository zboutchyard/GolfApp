//
//  ProfileInfoView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct ProfileInfoView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel
    @ObservedObject var msgViewModel: MessageViewModel
    @State var user: User?
    @State var otherUser: OtherUser?
    @State var isOtherUserProfile: Bool = false
    @State var isLoading: Bool = true
    @State var isAddPostClicked: Bool = false
    @State var isPostSubmitted: Bool = false
    @State var shouldShowImagePicker: Bool = false
    @State var shouldShowMoreOptionsView: Bool = false
    @State var selectedPost: Post = Post(id: "", text: "", timeStamp: Date.now, user: "")
    
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
                    .sheet(isPresented: $isAddPostClicked, content: {
                        if let user = authViewModel.user {
                            NewPostView(
                                authViewModel: authViewModel, user: user,
                                shouldAutoOpenImagePicker: $shouldShowImagePicker,
                                onPostSubmitted: {
                                authViewModel.state = .loading
                                authViewModel.fetchAllPostsFromFirebase { _ in
                                    authViewModel.state = .loaded
                                }
                                isPostSubmitted = true
                            })
                            .onDisappear {
                                shouldShowImagePicker = false
                            }
                        }
                    })
                    .sheet(isPresented: $shouldShowMoreOptionsView) {
                        MoreOptionsSheetView(authViewModel: authViewModel, post: $selectedPost)
                    }
                    
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
                                VStack {
                                    HStack {
                                        HStack {
                                            UserProfileImage(authViewModel: authViewModel)
                                            inputPostView
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding([.top, .leading, .bottom])
                                        inputImageView
                                    }
                                    .background(.whiteOrDark)
                                    Spacer().frame(height: 8)
                                }
                            }
                            .background(Color.appGray)
                            VStack {
                                if !authViewModel.userPosts.isEmpty {
                                    ForEach(authViewModel.posts, id: \.id) { post in
                                        if let user = authViewModel.user, let otherUser = authViewModel.postOtherUsers {
                                            PostsWithAdsView(
                                                authViewModel: authViewModel,
                                                notificationViewModel: notificationViewModel,
                                                msgViewModel: msgViewModel,
                                                user: user,
                                                post: post,
                                                otherUser: otherUser[post.user],
                                                index: authViewModel.posts.firstIndex(where: { $0.id == post.id }) ?? 0,
                                                shouldShowMoreOptionsView: $shouldShowMoreOptionsView,
                                                selectedPost: $selectedPost
                                            )
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
                                    ForEach(authViewModel.userPosts, id: \.self) { post in
                                        PostView(authViewModel: authViewModel,
                                                 notificationViewModel: notificationViewModel,
                                                 msgViewModel: msgViewModel,
                                                 post: post,
                                                 otherUser: otherUser,
                                                 shouldShowMoreOptionsView: $shouldShowMoreOptionsView,
                                                 selectedPost: $selectedPost)
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
    @ViewBuilder
    var inputImageView: some View {
        Button(action: {
            shouldShowImagePicker = true
            isAddPostClicked = true
        }, label: {
            HStack {
                Image(systemName: "photo.on.rectangle.angled")
                    .padding(.trailing)
            }
        })
        .buttonStyle(.plain)
    }
    @ViewBuilder
    var inputPostView: some View {
        VStack {
            Button(action: {
                isAddPostClicked = true
            }, label: {
                Text("tell me something...")
            })
            .buttonStyle(.plain)
            .opacity(0.3)
        }
    }
}

 struct UserProfileImage: View {
    @ObservedObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            if let data = authViewModel.user?.profilePicData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .background {
                        Circle().fill(Color("AppGray"))
                    }
                self.foregroundStyle(.whiteOrDark)
            } else {
                Image(systemName: "person.fill")
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .background {
                        Circle().fill(Color("AppGray"))
                    }
                    .foregroundStyle(.whiteOrDark)
            }
        }
    }
}
// #Preview {
//    ProfileInfoView(user: User(firstName: "Zack", lastName: "Boutchyard", email: "zackboutchyard@gmail.com", chats: ["123123"], friendsList: ["123123"], bio: "Here is a short bio about a boy who was sitting on the ouch doing nothing but coding for months so he could get maybe a slightly bigger paycheck", handicap: 12, homeCourse: "asheboro municipal"), isLoading: false)
// }
