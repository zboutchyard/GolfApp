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
                    TeeTimeView()
                        .tabItem {
                            Label("Tee Time", systemImage: "figure.golf")
                        }
                    AlertView()
                        .tabItem {
                            Label("Notifications", systemImage: "bell.fill")
                        }
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
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
    }
    func fetchUser() async {
        authViewModel.fetchUserDataFromFirebase { fetchedUser in
            user = fetchedUser
        }
    }
}

