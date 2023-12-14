//
//  Step3View.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import SwiftUI
import FirebaseStorage


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
    let storageReference = Storage.storage().reference().child("\(UUID().uuidString)")
    @State var interests: Array = [
        "baseball",
        "football",
        "basketball",
        "tennis",
        "soccer",
        "volleyball",
        "softball"
    ]
    @State var data: Data?
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
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140, maximum: 120))], alignment: .center, spacing: 25) {
                        ForEach(interests, id: \.self) { item in
                            Button(action: {
                                toggleInterest(interest: item)
                            }, label: {
                                Text(item)
                                    .foregroundStyle(selectedInterests.contains(item) ? Color.white : Color.black)
                                    .frame(width: 80, height: 10)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(selectedInterests.contains(item) ? Color.blue : Color.gray, lineWidth: 2)
                                            .fill(selectedInterests.contains(item) ? Color.blue : Color.white))
                            })
                        }
                    }
                    Text("Almost done... Let's add a few of your interests or hobbies.")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)
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
        authViewModel.registerUserWithFirebase(email: email, password: password, firstName: firstName,  profilePic: storageReference.name, lastName: lastName, bio: bio ?? "", interests: interestsString, handicap: handicap, homeCourse: homeCourse) { error in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    storageReference.putData(data, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            return
                        }
                    }
                }
                
                isStepComplete = true
            }
        }
    }
}


