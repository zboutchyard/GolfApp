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
    @StateObject var authViewModel: AuthViewModel
    @StateObject var msgViewModel: MessageViewModel = .init()
    @StateObject var notificationViewModel: NotificationViewModel = .init()
    @StateObject var searchViewModel: CourseSearchViewModel = .init()
    @State var isSettingsButtonClicked = false
    @State var isProfileView = false
    @State private var selectedTab: Int = 0
    
    init(authViewModel: AuthViewModel) {
        UITabBar.appearance().backgroundColor = UIColor.whiteOrDark
        _authViewModel = StateObject(wrappedValue: authViewModel)
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
                        Image(systemName: "gear").tint(.heading)
                    })
                    .font(.system(size: 25))
                    .padding(.trailing)
                }
                Button(action: {
                    Task {
                        isSearchBtnClicked = true
                    }
                }, label: {
                    Image(systemName: "magnifyingglass").tint(.heading)
                })
                .font(.system(size: 25))
                .padding(.trailing)
                Button(action: {
                    isMessageBtnClicked = true
                }, label: {
                    Image(systemName: "message").tint(.heading)
                })
                .font(.system(size: 25))
                .padding(.trailing)
            }
            .padding(.bottom, 15)
            .background(.whiteOrDark)
            Divider()
            TabView(selection: $selectedTab) {
                switch authViewModel.state {
                case .loading:
                    ProgressView()
                case .loaded:
                        HomeView(authViewModel: authViewModel, notificationViewModel: notificationViewModel, msgViewModel: msgViewModel)
                            .refreshable {
                                await authViewModel.fetchAllDataForLandingView()
                                selectedTab = selectedTab
                            }
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }
                            .tag(0)
                            .onAppear {
                                isProfileView = false
                            }
                    
                    ScoreCardView(authViewModel: authViewModel, searchModel: searchViewModel)
                        .tabItem {
                            Label("Score Card", systemImage: "figure.golf")
                        }
                        .tag(1)
                        .onAppear {
                            isProfileView = false
                        }
                    AlertView(
                        authViewModel: authViewModel,
                        notificationViewModel: notificationViewModel, msgViewModel: msgViewModel
                    )
                    .refreshable {
                        await authViewModel.fetchAllDataForLandingView()
                        selectedTab = selectedTab
                    }
                    .tabItem {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    .tag(2)
                    .onAppear {
                        isProfileView = false
                    }
                    ProfileView(
                        authViewModel: authViewModel,
                        notificationViewModel: notificationViewModel,
                        msgViewModel: msgViewModel)
                    .refreshable {
                        await authViewModel.fetchAllDataForLandingView()
                        selectedTab = selectedTab
                    }
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(3)
                    .onAppear {
                        isProfileView = true
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.whiteOrDark, for: .tabBar)
                    .background(Color.whiteOrDark)
                case .error:
                    Text("Error")
                }
            }
            .tint(.heading)
            .background(Color.whiteOrDark)
            .padding(.top, 0)
        }
        .background(Color.whiteOrDark)
        .padding(.top, 0)
        .navigationDestination(isPresented: $isMessageBtnClicked) {
            if authViewModel.user != nil {
                AllChatsView(authViewModel: authViewModel, msgViewModel: msgViewModel, notificationViewModel: notificationViewModel)
                
            }
        }
        .navigationDestination(isPresented: $isSearchBtnClicked) {
            SearchDetailView(
                authViewModel: authViewModel,
                msgViewModel: msgViewModel,
                searchText: $searchText,
                isAddFriendView: .constant(true),
                notificationViewModel: notificationViewModel)
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
        .navigationDestination(isPresented: $isSettingsButtonClicked) {
            SettingsView()
                .navigationTitle("Settings")
        }
        .onAppear {
            Task {
                selectedTab = selectedTab
            }
        }
    }
}
