//
//  SettingsView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/16/23.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State var isUserSignedOut: Bool = false
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                Task {
                    authViewModel.signOut()
                    isUserSignedOut = true
                }
            }, label: {
                Text("Log out")
            })
            Spacer()
        }
        .navigationDestination(isPresented: $isUserSignedOut) {
            LoginView(isLoggedIn: false)
                .navigationBarBackButtonHidden()
        }
       
    }
}

//#Preview {
//    SettingsView()
//}
