//
//  GolfAppApp.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import Firebase

@main
struct GolfAppApp: App {
    @State private var isRegistered: Bool = false
    @State private var uid: String = ""
    
    func fetchCurrentUser() {
        if let user = Auth.auth().currentUser {
            uid = user.uid
        }
    }
    
    init() {
        FirebaseApp.configure()
        fetchCurrentUser()
    }
    var body: some Scene {
        WindowGroup {
            RegisterView(isRegistered: false)
            //TODO: set default font here
        }
    }
}
