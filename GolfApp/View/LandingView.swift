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
    @ObservedObject var msgViewModel: MessageViewModel = MessageViewModel()
    @State var isSettingsButtonClicked = false
    @State var isProfileView = false
    @State var isLoading: Bool = false
    @State var shouldReloadData: Bool = true
    @State private var selectedTab: Int = 0
    @State private var otherUserNotifications: [String: OtherUser] = [:]
    @State var otherUserPendingRequest: [OtherUser] = []


    
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
            TabView(selection: $selectedTab) {
                if isLoading {
                    ProgressView()
                } else {
                    if let user = authViewModel.user, let posts = authViewModel.posts, let otherUsers = authViewModel.postOtherUsers {
                        HomeView(authViewModel: authViewModel, onBack: fetchAllData)
                                .tabItem {
                                    Label("Home", systemImage: "house.fill")
                                }
                                .tag(0)
                                .onAppear() {
                                    isProfileView = false
                                }
                            ScoreCardView(authViewModel: authViewModel)
                                .tabItem {
                                    Label("Score Card", systemImage: "figure.golf")
                                }
                                .tag(1)
                                .onAppear() {
                                    isProfileView = false
                                }
                        AlertView(authViewModel: authViewModel, otherUserPendingRequest: otherUserPendingRequest, otherUserNotifications: otherUserNotifications)
                                .tabItem {
                                    Label("Notifications", systemImage: "bell.fill")
                                }
                                .tag(2)
                                .onAppear() {
                                    isProfileView = false
                                }
                        ProfileView(authViewModel: authViewModel, user: user)
                                .tabItem {
                                    Label("Profile", systemImage: "person.fill")
                                }
                                .tag(3)
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
            if let user = authViewModel.user {
                AllChatsView(authViewModel: authViewModel, msgViewModel: msgViewModel)

            }
        }
        .navigationDestination(isPresented: $isSearchBtnClicked) {
            if let currentUser = authViewModel.user {
                SearchDetailView(authViewModel: authViewModel ,searchText: $searchText, user: currentUser, isAddFriendView: .constant(true))
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
        .refreshable {
            fetchAllData()
            selectedTab = selectedTab
        }
        .onAppear() {
            if shouldReloadData {
                fetchAllData()
            }
            
            shouldReloadData = false
            selectedTab = selectedTab
            
        }
    }
    
    func fetchPosts(postIds: [String]) {
        authViewModel.fetchAllPostsInUserObject(postIds: postIds)
    }
    
    func fetchAllData() {
        isLoading = true
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            let token = Messaging.messaging().fcmToken
            if let user = fetchedUser {
                if (token != user.fcmToken) {
                    authViewModel.updateFcmToken()
                }
            }
            if fetchedUser?.receivedRequests != nil {
                fetchOtherUsersByRequest()
            }
            if let notifications = fetchedUser?.notifications {
                isLoading = true
                for notification in notifications {
                    fetchUserInfoById(userId: notification.userCommenting)
                }
                isLoading = false
            }
            if let friends = authViewModel.user?.friendsList {
                getFriendsList(friendsList: friends)

            }
            fetchOtherUsers()
            fetchAllPostsAndUserData()
            if let userPosts = authViewModel.user?.posts {
                fetchPosts(postIds: userPosts)
            }
        }
    }
    
    func fetchUserInfoById(userId: String) {
        authViewModel.fetchOtherUserFromFirebase(id: userId) { fetchedOtherUser in
            otherUserNotifications[userId] = fetchedOtherUser
        }
    }
    
    func fetchOtherUsersByRequest() {
        if let user = authViewModel.user {
            if let receivedRequests = user.receivedRequests {
                for request in receivedRequests {
                    authViewModel.fetchOtherUserFromFirebase(id: request.user) { fetchedOtherUser in
                        // Check if the fetched user is not already in the array
                        if !otherUserPendingRequest.contains(where: { user in
                            return user.id == fetchedOtherUser?.id // Update with the actual property used for comparison
                        }) {
                            // Append the fetched user to the array
                            if let fetchedUser = fetchedOtherUser {
                                otherUserPendingRequest.append(fetchedUser)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func fetchOtherUsers() {
        authViewModel.fetchAllOtherUsersFromFirebase() { users in
        }
    }
    
    func getFriendsList(friendsList: [String]){
        authViewModel.fetchFriendsFromFirebase(ids: friendsList) { allFriends in
        }
    }
    
    func fetchAllPostsAndUserData() {
        authViewModel.fetchAllPostsFromFirebase() { fetchedPosts in
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
            completion()
        }
    }
}

