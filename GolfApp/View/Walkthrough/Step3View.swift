//
//  Step3View.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI

struct Step3View: View {
    @StateObject var authViewModel = AuthViewModel()
    //    @StateObject var mockViewModel = MockAuthViewModel()
    @State private var user: User?
    @State var isStepComplete: Bool = false
    @State private var selectedInterests: [String] = []
    @State private var isSelected: Bool = false
    @State var interestsString: String?
    @State var email: String
    @State var password: String
    @State var firstName: String
    @State var lastName: String
    @State var bio: String?
    @State var handicap: Int?
    @State var homeCourse: String?
    @State var interests: Array = [
        "baseball",
        "football",
        "basketball",
        "tennis",
        "soccer",
        "volleyball",
        "softball"
    ]
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            isStepComplete = true
                        }, label: {
                            Text("Skip")
                        })
                        
                    }
                    .fontWeight(.semibold)
                    .kerning(1.2)
                    Spacer()
                    //some "interests" tiles that a user can click that will be added into an array and sent to firebase
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 120))], alignment: .center, spacing: 50) {
                        ForEach(interests, id: \.self) { item in
                            Button(action: {
                                toggleInterest(interest: item)
                                print(selectedInterests)
                            }, label: {
                                Text(item)
                                    .frame(width: 80, height: 10)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(selectedInterests.contains(item) ? Color.blue : Color.gray, lineWidth: 2)
                                    )
                            })
                        }
                    }
                    Text("Almost done... Let's add a few of your interests or hobbies.")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    Spacer(minLength: 100)
                }
            }
            .overlay(
                Button(action: {
                    if !selectedInterests.isEmpty {
                        interestsString = selectedInterests.joined(separator: ", ")
                    }
                    registerUser(interests: interestsString ?? "")
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
                                    .trim(from: 0, to: 0.75)
                                    .stroke(Color.green, lineWidth: 4)
                                    .rotationEffect(.init(degrees: -90))
                            }
                                .padding(-15)
                        )
                })
                ,alignment: .bottom
            )
            
            .navigationDestination(isPresented: $isStepComplete) {
                LandingView()
                    .navigationBarBackButtonHidden()
                    .toolbar(.hidden)
            }
            .padding()
        }
    }
    
    
    func toggleInterest(interest: String) {
        if selectedInterests.contains(interest) {
            if let index = selectedInterests.firstIndex(of: interest) {
                selectedInterests.remove(at: index)
            }
        } else {
            selectedInterests.append(interest)
        }
        isSelected.toggle()
    }
    func registerUser(interests: String) {
        authViewModel.registerUserWithFirebase(email: email, password: password, firstName: firstName, lastName: lastName, bio: bio ?? "", interests: interestsString, handicap: handicap, homeCourse: homeCourse) { error in
            if let error = error {
                print(error)
            } else {
                isStepComplete = true
            }
        }
    }
}


