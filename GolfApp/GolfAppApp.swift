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
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser?.email != nil {
                NavigationStack {
                    LandingView()
                }
            }else {
                RegisterView(isRegistered: false)
            }
        }
    }
}
