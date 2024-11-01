//
//  ContentView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var uid: String = ""
    @State private var shouldPresentForgotPasswordView: Bool = false
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
                }
                .buttonStyle(.borderedProminent)
                .padding(.leading)
                .padding(.trailing)
                .padding(.top)
                Button("Forgot password") {
                    shouldPresentForgotPasswordView = true
                }
                .buttonStyle(.plain)
                .underline()
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                LandingView()
                    .navigationBarBackButtonHidden()
                    .toolbar(.hidden)
            }
        }
        .padding()
        .navigationDestination(isPresented: $shouldPresentForgotPasswordView) {
            ForgotPasswordView()
        }
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

struct ForgotPasswordView: View {
    @State var emailText: String = ""
    @StateObject var authViewModel: AuthViewModel = AuthViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "person.fill.questionmark")
                .resizable()
                .frame(width: 110, height: 100)
                .foregroundStyle(Color.green.opacity(0.4))
                .padding(.bottom, 20)
            Text("Forgot your password?")
                .font(.title2)
                .fontWeight(.bold)
                .kerning(0.2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Text("Enter your email below to receive your password reset instructions")
                .font(.subheadline)
                .fontWeight(.light)
                .kerning(0.2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading, 5)
                
                TextField("Enter your email", text: $emailText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.top, 20)
            resetPasswordButton(emailText: emailText)
                .padding(.top, 20)
        }
        .padding(.horizontal, 60)
    }
    
    @ViewBuilder
    func resetPasswordButton(emailText: String) -> some View {
        VStack {
            RoundedCorner(radius: 10, corners: .allCorners)
                .fill(Color.green)
                .frame(height: 50)
                .overlay {
                    Button {
                        if !emailText.isEmpty {
                            authViewModel.resetPassword(email: emailText) { _ in
                                // maybe not do anything here?
                            }
                        } else {
                            // TODO: add error, also need to check if text is valid email format
                        }
                    } label: {
                        Text("Reset Password")
                            .fontWeight(.medium)
                            .font(.title2)
                            .kerning(0.8)
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}
