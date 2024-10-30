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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ViewSwitcher()
            }
        }
    }
}

struct ViewSwitcher: View {
    var body: some View {
        Group {
            if Auth.auth().currentUser != nil {
                LandingView()
            } else {
                RegisterView(isRegistered: false)
            }
        }
    }
}
