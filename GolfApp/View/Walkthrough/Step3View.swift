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
    @State private var isLoading: Bool = true
    @State var isStepComplete: Bool = false
    @State private var selectedInterests: [String] = []
    @State private var isSelected: Bool = false
    let interests: Array = [
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
                        if !isLoading {
                            if let user = user {
                                Text("Hello \(user.firstName)!")
                                    .padding()
                                Spacer()
                                Button(action: {
                                    isStepComplete = true
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
                                    .foregroundColor(.black)
                            })
                        }
                    }
                    
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
                Button(action: {
                    isStepComplete = true
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
            .onAppear(){
                fetchData()
            }
            .navigationDestination(isPresented: $isStepComplete) {
                LandingView()
                    .navigationBarBackButtonHidden()
                    .toolbar(.hidden)
            }
            .padding()
        }
    }
    func fetchData() {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
            isLoading = false
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
}

#Preview {
    Step3View()
}
