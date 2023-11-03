//
//  GolfApp
//
//  Created by Zack Boutchyard on 11/5/23.
//

import SwiftUI

struct Step2View: View {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var mockViewModel = MockAuthViewModel()
    @State private var user: User?
    @State private var isLoading: Bool = true
    @State var bioText: String = ""
    @State var charLimitReached: Bool = false
    let characterLimit = 120
    var remainingCharacters: Int {
        if(characterLimit - bioText.count < 0){
            charLimitReached = true
        }
        return characterLimit - bioText.count
    }
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
                Text(remainingCharacters >= 0 ? "Remaining Characters: \(remainingCharacters)": "You have exceeded the character limit")
                    .foregroundColor(remainingCharacters > -1 ? .green : .red)
                    .font(.caption)
                    .padding()
                TextField("...Tell us something", text: $bioText)
                    .padding()
                    .font(.system(size: 12))
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: .init(1.0)))
                Text("Step 2")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding(.top)
                Text("Now briefly tell us something about yourself.")
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
                                .trim(from: 0, to: 0.5)
                                .stroke(Color.green, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                            .padding(-15)
                    ) .disabled(charLimitReached == true)
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
    Step2View()
}
