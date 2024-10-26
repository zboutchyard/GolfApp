//
//  HomeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI
import AlertToast

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject var notificationViewModel: NotificationViewModel
    @StateObject var msgViewModel: MessageViewModel
    @State private var postSubmissionText: String = ""
    @State var isAddPostClicked: Bool = false
    @State var isPostSubmitted: Bool = false
    @State private var postCounter = 0
    
    var body: some View {
        
        ScrollView {
            if authViewModel.state == .loading {
                LoadingView()
            } else if authViewModel.state == .loaded {
                VStack {
                    HStack {
                        HStack {
                            userProfileImage
                            inputPostView
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .leading, .bottom])
                        inputImageView
                    }
                    .background(.whiteOrDark)
                    Spacer().frame(height: 8)
                    postAndAdsView
                }
                .sheet(isPresented: $isAddPostClicked, content: {
                    if let user = authViewModel.user {
                        NewPostView(authViewModel: authViewModel, user: user, onPostSubmitted: {
                            authViewModel.state = .loading
                            authViewModel.fetchAllPostsFromFirebase { _ in
                                authViewModel.state = .loaded
                            }
                            isPostSubmitted = true
                        })
                    }
                })
            } else {
                VStack {
                    Text("Error")
                }
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.blackOrGray)
        .toast(isPresenting: $isPostSubmitted, alert: {
            AlertToast(displayMode: .alert, type: .systemImage("checkmark", .mint), title: "Post submitted")
        })
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
    
    @ViewBuilder
    var userProfileImage: some View {
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
    
    @ViewBuilder
    var inputImageView: some View {
        Button(action: {
            // TODO: add logic for adding a new photo
        }, label: {
            HStack {
                Image(systemName: "photo.on.rectangle.angled")
                    .padding(.trailing)
            }
        })
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var postAndAdsView: some View {
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
    }
}
