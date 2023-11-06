//
//  WalkthroughView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/5/23.
//

import SwiftUI

struct Step1View: View {
    @StateObject var authViewModel = AuthViewModel()
//    @StateObject var mockViewModel = MockAuthViewModel()
    @State private var user: User?
    @State private var isStep1Complete: Bool = false
    @State private var isLoading: Bool = true
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        if !isLoading {
                            if let user = user {
                                Text("Hello \(user.firstName)!")
                                    .padding()
                                Spacer()
                                Button(action: {
                                    isStep1Complete = true
                                }, label: {
                                    Text("Skip")
                                })
                                
                            } else {
                                Text("User Data not available")
                            }
                        }
                    }
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .kerning(1.2)
                    Spacer()
                    EditableCircularProfileImage(viewModel: authViewModel)
                    Text("Step 1")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .padding(.top)
                    Text("Let's start by getting an image for your profile.")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .kerning(1.2)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    Spacer(minLength: 100)
                }
                if isLoading {
                    ProgressView("Fetching your profile information")
                        .progressViewStyle(.circular)
                        .padding()
                }
            }
            .overlay(
                Button(action: {
                    isStep1Complete = true
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .overlay(
                            ZStack{
                                Circle()
                                    .stroke(Color.black.opacity(0.04), lineWidth: 4)
                                Circle()
                                    .trim(from: 0, to: 0.3)
                                    .stroke(Color.green, lineWidth: 4)
                                    .rotationEffect(.init(degrees: -90))
                            }
                                .padding(-15)
                        )
                })
                ,alignment: .bottom
            )
            .onAppear(){
                fetchData()
            }
            .navigationDestination(isPresented: $isStep1Complete){
                Step2View()
            }
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
    func fetchData() {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
            isLoading = false
        }
    }
}

#Preview {
    Step1View()
}
