//
//  Step3View.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI

struct Step3View: View {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var mockViewModel = MockAuthViewModel()
    @State private var user: User?
    @State private var isLoading: Bool = true
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if !isLoading {
                        if let user = user {
                            Text("Hello \(user.firstName)!")
                                .padding()
                            Spacer()
                            Button(action: {
                                
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
                //some "interests" tiles that a user can click that will be added into an array and sent to firebase
                Text("Step 3")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding(.top)
                Text("Almost done... Let's add a few of your interests or hobbies.")
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
            Button(action: {}, label: {
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
                                .trim(from: 0, to: 0.75)
                                .stroke(Color.green, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                            .padding(-15)
                    ) //.disabled(charLimitReached == true)
            })
            ,alignment: .bottom
        )
        .onAppear(){
            fetchData()
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
    func fetchData() {
        mockViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
            isLoading = false
        }
    }
}

#Preview {
    Step3View()
}
