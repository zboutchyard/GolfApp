//
//  HomeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI
import AlertToast

struct HomeView: View {
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @State private var postSubmissionText: String = ""
    @State var user: User?
    @State var isAddPostClicked: Bool = false
    @State var isPostSubmitted: Bool = false
    @State var isLoading: Bool = false
    @State var posts: [Post]?
    @State var otherUser: OtherUser?
    @State var otherUsers: [String: OtherUser] = [:]
    @Binding var selectedTab: Int?
    var onBack: () -> Void


    
    var body: some View {
        ScrollView {
            if isLoading {
                LoadingView()
            } else {
                VStack {
                    HStack {
                        HStack {
                            if let data = user?.profilePicData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .background {
                                        Circle().fill(Color("AppGray"))
                                    }
                                    .foregroundStyle(.whiteOrDark)
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
                            Button(action: {
                                isAddPostClicked = true
                            }, label: {
                                Text("tell me something...")
                            })
                            .buttonStyle(.plain)
                            .opacity(0.3)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .leading, .bottom])
                        Button(action: {}, label: {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .padding(.trailing)
                            }
                        })
                        .buttonStyle(.plain)
                    }
                    .ignoresSafeArea()
                    .background(.whiteOrDark)
                    Spacer().frame(height: 8)
                    VStack {
                        if let posts = posts {
                            ForEach(posts.sorted(by: { $0.timeStamp > $1.timeStamp }), id: \.self) { post in
                                if let user = user {
                                    PostView(selectedTab: $selectedTab, user: user, post: post, otherUser: otherUsers[post.user] ,onBack: onBack)
                                }
                            }
                        } else {
                            LoadingView()
                        }
                        
                        
                        
                    }
                }
                .sheet(isPresented: $isAddPostClicked, content: {
                    if let user = user {
                        NewPostView(user: user, onPostSubmitted: {
                            isLoading = true
                            authViewModel.fetchAllPostsFromFirebase() { fetchedPosts in
                                posts = fetchedPosts
                                isLoading = false
                            }
                            isPostSubmitted = true
                        })
                    }
                })
            }    
        }
        .frame(maxHeight: .infinity)
        .background(Color.blackOrGray)
        .toast(isPresenting: $isPostSubmitted, alert: {
            AlertToast(displayMode: .alert, type: .systemImage("checkmark", .mint), title: "Post submitted")
        })
    }
}

//#Preview {
//    HomeView()
//}
