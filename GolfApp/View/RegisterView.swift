//
//  RegisterView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var image: UIImage?
    @State var isRegistered: Bool
    @StateObject var authViewModel = AuthViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Text("Register")
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
                SecureField("Confirm Password", text: $passwordConfirm)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                Button("Register"){
                    Task {
                        registerUser()
                    }
                }.buttonStyle(.borderedProminent)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                NavigationLink( destination: LoginView(isLoggedIn: false)) {
                    Text("Already have an account? Log in")
                        .underline()
                }
                .navigationBarBackButtonHidden()
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                    .navigationDestination(isPresented: $isRegistered) {
                        Step1View()
                    }
                    
            }
        }
        .padding()
    }
    func registerUser() {
        authViewModel.registerUserWithFirebase(email: email, password: password, firstName: firstName, lastName: lastName) { error in
            if let error = error {
                print(error)
            } else {
                isRegistered = true
            }
        }
    }
}

#Preview {
    RegisterView(isRegistered: false)
}
