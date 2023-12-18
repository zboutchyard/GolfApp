//
//  GolfAppApp.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct GolfAppApp: App {
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ViewSwitcher()
            }
        }
        .environmentObject(authViewModel)
    }
}

struct ViewSwitcher: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if (authViewModel.isUserLoggedIn) {
                LandingView()
        }else {
            RegisterView(isRegistered: false)
        }
    }
}
