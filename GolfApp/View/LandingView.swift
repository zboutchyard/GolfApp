//
//  TabView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI

struct LandingView: View {
    @State private var isMessageBtnClicked = false
    @State private var isSearchBtnClicked = false
    @State private var searchText: String = ""
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State var user: User?
    @State var isSettingsButtonClicked = false
    @State var isProfileView = false
    
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
                            await fetchUser()
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
                        await fetchUser()
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
                    HomeView()
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
                    ProfileView()
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
    }
    func fetchUser() async {
        authViewModel.fetchUserDataFromFirebase { fetchedUser in
            user = fetchedUser
        }
    }
}

