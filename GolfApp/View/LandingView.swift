//
//  TabView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI

struct LandingView: View {
    @State private var isMessageBtnClicked = false
    @State private var selectedTab: Tab = .home
    @State private var isSearchBtnClicked = false
    @State private var searchText: String = ""
    enum Tab {
        case home
        case profile
        case chatView
        case teeTimeView
    }
    var body: some View {
        NavigationStack {
            HStack {
                Text("par pal")
                    .font(.title).bold()
                    .foregroundStyle(Color("Heading"))
                    .padding(.leading)
                Spacer()
                Button(action: {
                    isSearchBtnClicked = true
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
                .font(.system(size: 25))
                .padding(.trailing)
                Button(action: {
                    isMessageBtnClicked = true
                }, label: {
                    Image(systemName: "plus.message")
                })
                .font(.system(size: 25))
                .padding(.trailing)
            }
            
            Divider()
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(Tab.home)
                TeeTimeView()
                    .tabItem {
                        Label("Tee Time", systemImage: "figure.golf")
                    }
                    .tag(Tab.teeTimeView)
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(Tab.profile)
            }
            .navigationBarBackButtonHidden()
        } .navigationDestination(isPresented: $isMessageBtnClicked) {
            AllChatsView()
        }
        .navigationDestination(isPresented: $isSearchBtnClicked) {
            SearchDetailView(searchText: $searchText)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        TextField("search users", text: $searchText)
                            .padding(4)
                            .font(.system(size: 20))
                            .background(RoundedRectangle(cornerRadius: 30).stroke(Color.gray, lineWidth: .init(1.0)))
                    }
                })
        }
    }
}

#Preview {
    LandingView()
}
