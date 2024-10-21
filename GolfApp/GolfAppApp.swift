//
//  GolfAppApp.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseMessaging

@main
struct GolfAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    
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
    @State var fmcToken = Messaging.messaging().fcmToken
    @State var deviceToken = Messaging.messaging().apnsToken
    var body: some View {
        Group {
            if authViewModel.isUserLoggedIn {
                LandingView(authViewModel: authViewModel)
            } else {
                RegisterView(isRegistered: false, authViewModel: authViewModel)
            }
        }
    }
}
