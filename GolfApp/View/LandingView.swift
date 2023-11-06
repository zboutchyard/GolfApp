//
//  TabView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import SwiftUI

struct LandingView: View {
    @State private var selectedTab: Tab = .home
    enum Tab {
        case home
        case profile
    }
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LandingView()
}
