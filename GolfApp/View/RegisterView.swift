//
//  RegisterView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseAuth
import AlertToast

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var image: UIImage?
    @State var isRegistered: Bool
    @State var showEmailError = false
    @State var showMissingPassword = false
    @State var showFirstNameError = false
    @State var showLastNameError = false
    @State var showPasswordMismatch = false
    @State var showInvalidEmail = false
    @State var showInvalidPassword = false
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
                    .onChange(of: email) {
                        showEmailError = false
                        showInvalidEmail = false
                    }
                if showEmailError {
                    Text("Please enter email address")
                        .foregroundStyle(.red)
                        .fontWeight(.light)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                if showInvalidEmail, !showEmailError {
                    Text("email address is invalid")
                        .foregroundStyle(.red)
                        .fontWeight(.light)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                    .onChange(of: password) {
                        showMissingPassword = false
                        showPasswordMismatch = false
                    }
                if showMissingPassword {
                    Text("please enter password")
                        .foregroundStyle(.red)
                        .fontWeight(.light)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                
                SecureField("Confirm Password", text: $passwordConfirm)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                    .onChange(of: passwordConfirm) {
                        showMissingPassword = false
                        showPasswordMismatch = false
                    }
                if showMissingPassword {
                    Text("please enter password")
                        .foregroundStyle(.red)
                        .fontWeight(.light)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                    .onChange(of: firstName) {
                        showFirstNameError = false
                    }
                if showFirstNameError {
                    Text("please enter first name")
                        .foregroundStyle(.red)
                        .fontWeight(.light)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                    .onChange(of: lastName) {
                        showLastNameError = false
                    }
                if showLastNameError {
                    Text("please enter first name")
                        .foregroundStyle(.red)
                        .fontWeight(.light)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                Button("Register") {
                    Task {
                        if email.isEmpty {
                            showEmailError = true
                        }
                        if password.isEmpty {
                            showMissingPassword = true
                        }
                        if passwordConfirm.isEmpty {
                            showMissingPassword = true
                        }
                        if firstName.isEmpty {
                            showFirstNameError = true
                        }
                        if lastName.isEmpty {
                            showLastNameError = true
                        }
                        if passwordConfirm != password {
                            showPasswordMismatch = true
                        }
                        if validatePassword(password: password) == true {
                            showInvalidPassword = true
                        }
                        if isEmailValid(email) == false {
                            showInvalidEmail = true
                        }
                        if !email.isEmpty, !password.isEmpty, !passwordConfirm.isEmpty, !firstName.isEmpty, !lastName.isEmpty, !showPasswordMismatch {
                            isRegistered = true
                        }
                    }
                }.buttonStyle(.borderedProminent)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                NavigationLink( destination: LoginView(isLoggedIn: false)) {
                    Text("Already have an account? Log in")
                        .underline()
                }
                if showInvalidPassword {
                    VStack {
                        Section {
                            Text("Password requirements:")
                                .font(.headline)
                                .opacity(0.6)
                            Text("Must contain at least one uppercase letter")
                                .font(.caption)
                                .padding(.top, 3)
                                .opacity(0.6)
                            Text("Must contain at least one lowercase letter")
                                .font(.caption)
                                .opacity(0.6)
                            Text("Must contain at least one number")
                                .font(.caption)
                                .opacity(0.6)
                            Text("Must contain at least one special character")
                                .font(.caption)
                                .opacity(0.6)
                        }
                    }
                    .padding(.top)
                }
               
                }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $isRegistered) {
                Step1View(email: email, password: password, firstName: firstName, lastName: lastName)
                
            }
        }
        .toast(isPresenting: $showPasswordMismatch) {
            AlertToast(displayMode: .alert, type: .error(.red), title: "Passwords do not match")
        }
    }
    func isEmailValid(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    func validatePassword(password: String) -> Bool {
        let specialCharacterSet = CharacterSet(charactersIn: "!@#$%^&*()-_=+[]{}|;:'\"<>,.?/~")
        if password.count < 12,
           password.rangeOfCharacter(from: .uppercaseLetters) == nil,
           password.rangeOfCharacter(from: .lowercaseLetters) == nil,
           password.rangeOfCharacter(from: .decimalDigits) == nil,
           password.rangeOfCharacter(from: specialCharacterSet) == nil {
            return false
        } else {
            return true
        }
    }
    
}
