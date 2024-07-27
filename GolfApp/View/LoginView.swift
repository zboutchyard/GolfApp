//
//  ContentView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject var authViewModel: AuthViewModel
    @State var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var uid: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                Button("Login") {
                    Task {
                        login()
                    }
                }.buttonStyle(.borderedProminent)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                    LandingView(authViewModel: authViewModel)
                        .navigationBarBackButtonHidden()
                        .toolbar(.hidden)
            }
        }
        .padding()
    }
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle login error
                print("Login failed: \(error.localizedDescription)")
            } else {
                uid = authResult?.user.uid ?? ""
                isLoggedIn = true
            }
        }
    }
}
