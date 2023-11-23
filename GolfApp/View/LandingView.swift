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
    }
}

#Preview {
    LandingView()
}
