//
//  TabView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI
import FirebaseMessaging


struct LandingView: View {
    @State private var isMessageBtnClicked = false
    @State private var isSearchBtnClicked = false
    @State private var searchText: String = ""
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State var user: User?
    @State var isSettingsButtonClicked = false
    @State var isProfileView = false
    @State var isLoading: Bool = false
    @State var posts: [Post]?
    @State var otherUsers: [String: OtherUser] = [:]
    @State var shouldReloadData: Bool = true

    
    init() {
    UITabBar.appearance().backgroundColor = UIColor.whiteOrDark
    }
  
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("par pals")
                    .font(.title).bold()
                    .foregroundStyle(Color("Heading"))
                    .padding(.leading)
                Spacer()
                if isProfileView {
                    Button(action: {
                        Task {
                            isSettingsButtonClicked = true
                        }
                    }, label: {
                        Image(systemName: "gear")
                    })
                    .font(.system(size: 25))
                    .padding(.trailing)
                }
                Button(action: {
                    Task {
                        isSearchBtnClicked = true
                    }
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
                .font(.system(size: 25))
                .padding(.trailing)
                Button(action: {
                    isMessageBtnClicked = true
                }, label: {
                    Image(systemName: "message")
                })
                .font(.system(size: 25))
                .padding(.trailing)
            }
            .padding(.bottom, 15)
            .background(.whiteOrDark)
            Divider()
            TabView() {
                if isLoading {
                    LoadingView()
                } else {
                    if let user = user, let posts = posts, !otherUsers.isEmpty {
                        HomeView(user: user, posts: posts, otherUsers: otherUsers)
                                .tabItem {
                                    Label("Home", systemImage: "house.fill")
                                }
                                .onAppear() {
                                    isProfileView = false
                                }
                            TeeTimeView()
                                .tabItem {
                                    Label("Tee Time", systemImage: "figure.golf")
                                }
                                .onAppear() {
                                    isProfileView = false
                                }
                            AlertView()
                                .tabItem {
                                    Label("Notifications", systemImage: "bell.fill")
                                }
                                .onAppear() {
                                    isProfileView = false
                                }
                        ProfileView(authViewModel: authViewModel, user: user)
                                .tabItem {
                                    Label("Profile", systemImage: "person.fill")
                                }
                                .onAppear() {
                                    isProfileView = true
                                }
                        
                        .toolbar(.visible, for: .tabBar)
                        .toolbarBackground(Color.whiteOrDark, for: .tabBar)
                        .background(Color.whiteOrDark)
                    }
                }
                
                
            }
            .background(Color.whiteOrDark)
            .padding(.top, 0)
        }
        .background(Color.whiteOrDark)
        .padding(.top, 0)
        .navigationDestination(isPresented: $isMessageBtnClicked) {
            AllChatsView()
        }
        .navigationDestination(isPresented: $isSearchBtnClicked) {
            if let currentUser = user {
                SearchDetailView(searchText: $searchText, user: currentUser, isAddFriendView: .constant(true))
                    .toolbar(content: {
                        ToolbarItem(placement: .principal) {
                            TextField("search users", text: $searchText)
                                .padding(.leading)
                                .padding(4)
                                .font(.system(size: 20))
                                .background(RoundedRectangle(cornerRadius: 30).stroke(Color.heading, lineWidth: .init(1.0)))
                        }
                    })
            }
        }
        .navigationDestination(isPresented: $isSettingsButtonClicked) {
            SettingsView()
                .navigationTitle("Settings")
        }
        .onAppear() {
            if shouldReloadData {
                fetchAllData()
            }
            
            shouldReloadData = false
            
        }
    }
    func fetchPosts(postIds: [String]) {
        authViewModel.fetchAllPostsInUserObject(postIds: postIds)
    }
    
    func fetchAllData() {
        isLoading = true
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
            let token = Messaging.messaging().fcmToken
            if let user = fetchedUser {
                if (token != user.fcmToken) {
                    authViewModel.updateFcmToken()
                }
            }
            fetchAllPostsAndUserData()
            if let userPosts = user?.posts {
                fetchPosts(postIds: userPosts)
            }
        }
    }
    
    func fetchAllPostsAndUserData() {
        authViewModel.fetchAllPostsFromFirebase() { fetchedPosts in
            self.posts = fetchedPosts

            let group = DispatchGroup()
            for post in fetchedPosts {
                group.enter()
                self.getOtherUserData(userId: post.user) {
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                // Now all user data is fetched, update the state to render HomeView
                self.isLoading = false
            }
        }
    }

    func getOtherUserData(userId: String, completion: @escaping () -> Void) {
        authViewModel.fetchOtherUserFromFirebase(id: userId) {  fetchedOtherUser in
            otherUsers[userId] = fetchedOtherUser
            completion()
        }
    }
}

