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
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
                   LandingView()
               } else {
                   RegisterView(isRegistered: false)
               }
           }
       }
   }

