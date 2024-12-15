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
    @ObservedObject var notificationViewModel: NotificationViewModel
    @ObservedObject var msgViewModel: MessageViewModel
    @State private var postSubmissionText: String = ""
    @State var isAddPostClicked: Bool = false
    @State var isPostSubmitted: Bool = false
    @State private var postCounter = 0
    @State var shouldShowImagePicker: Bool = false
    @State var shouldShowMoreOptionsView: Bool = false
    @State var selectedPost: Post = Post(id: "", text: "", timeStamp: Date.now, user: "")
    
    var body: some View {
        
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        HStack {
                            profileImageView
                            inputPostView
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .leading, .bottom])
                        inputImageView
                    }
                    .background(.whiteOrDark)
                    Spacer().frame(height: 8)
                    if !authViewModel.liveRounds.isEmpty {
                        liveRoundPostView
                    }
                    postAndAdsView
                }
                .sheet(isPresented: $isAddPostClicked, content: {
                    if let user = authViewModel.user {
                        NewPostView(authViewModel: authViewModel, user: user,
                                    shouldAutoOpenImagePicker: $shouldShowImagePicker,
                                    onPostSubmitted: {
                            isPostSubmitted = true
                        })
                        .onDisappear {
                            shouldShowImagePicker = false
                        }
                    }
                })
                
            }
            .sheet(isPresented: $shouldShowMoreOptionsView) {
                MoreOptionsSheetView(authViewModel: authViewModel, post: $selectedPost)
                    .presentationDetents([.height(400)])
            }
        }
        
        .frame(maxHeight: .infinity)
        .background(Color.blackOrGray)
        .toast(isPresenting: $isPostSubmitted, alert: {
            AlertToast(displayMode: .alert, type: .systemImage("checkmark", .mint), title: "Post submitted")
        })
    }
    
    @ViewBuilder
    var profileImageView: some View {
        UserProfileImage(authViewModel: authViewModel, profileImageData: authViewModel.user?.profilePicData)
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
    var postAndAdsView: some View {
        VStack {
            ForEach(authViewModel.posts, id: \.id) { post in
                if let user = authViewModel.user, let otherUser = authViewModel.postOtherUsers {
                    PostsWithAdsView(
                        authViewModel: authViewModel,
                        notificationViewModel: notificationViewModel,
                        msgViewModel: msgViewModel,
                        user: user,
                        post: post,
                        otherUser: otherUser[post.user],
                        index: authViewModel.posts.firstIndex(where: { $0.id == post.id }) ?? 0, // Optional: for index reference if needed
                        shouldShowMoreOptionsView: $shouldShowMoreOptionsView,
                        selectedPost: $selectedPost
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    var liveRoundPostView: some View {
        VStack {
            ForEach(0 ..< authViewModel.liveRounds.count, id: \.self) { index in
                LiveRoundPostView(viewModel: authViewModel, index: index)
                    .task {
                        await authViewModel.getOtherUsersForLiveRound(
                            mainUser: authViewModel.liveRounds[index].users.mainUser.id,
                            otherUser: authViewModel.liveRounds[index].users.otherUser.id)
                    }
            }
        }
    }
}
