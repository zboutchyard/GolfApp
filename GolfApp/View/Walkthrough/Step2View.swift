//
//  GolfApp
//
//  Created by Zack Boutchyard on 11/5/23.
//

import SwiftUI

struct Step2View: View {
    @StateObject var authViewModel = AuthViewModel()
    //    @StateObject var mockViewModel = MockAuthViewModel()
    @State var user: User?
    @State var bioText: String = ""
    @State var charLimitReached: Bool = false
    @State var isStepComplete: Bool = false
    let characterLimit = 120
    @State var email: String
    @State var password: String
    @State var firstName: String
    @State var lastName: String
    @State var handicap: Int = 0
    @State var homeCourse: String = ""
    @State var handicapSelection: [Int] = Array(-5...40)
    @State var data: Data?
    var remainingCharacters: Int {
        if(characterLimit - bioText.count < 0){
            charLimitReached = true
        }
        return characterLimit - bioText.count
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer()
                    VStack {
                        Spacer()
                        Text("Now briefly tell us something about yourself.")
                            .fontWeight(.semibold)
                            .kerning(1.2)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                        Text(remainingCharacters >= 0 ? "Remaining Characters: \(remainingCharacters)": "You have exceeded the character limit")
                            .foregroundColor(remainingCharacters > -1 ? .green : .red)
                            .font(.caption)
                            .padding()
                        TextField("...Tell us something", text: $bioText)
                            .padding()
                            .font(.system(size: 12))
                            .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: .init(1.0)))
                        Divider()
                            .padding(.top)
                        Spacer()
                        Text("What is your handicap?")
                            .fontWeight(.semibold)
                            .kerning(1.2)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                        Picker(selection: $handicap, label: Text("Handicap")) {
                            ForEach(handicapSelection, id: \.self) { value in
                                Text("\(value)")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                        Spacer()
                        Divider()
                            .padding(.top)
                        Text("Where is your home course?")
                            .fontWeight(.semibold)
                            .kerning(1.2)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                            .padding(.bottom)
                        TextField("...Home course", text: $homeCourse)
                            .padding()
                            .font(.system(size: 12))
                            .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: .init(1.0)))
                        
                    }
                
            }
            
        }
        .navigationDestination(isPresented: $isStepComplete) {
            Step3View(email: email, password: password, firstName: firstName, lastName: lastName, bio: bioText, handicap: handicap, homeCourse: homeCourse, data: data)
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
                                .trim(from: 0, to: 0.5)
                                .stroke(Color.green, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                            .padding(-15)
                    ) .disabled(charLimitReached == true)
            })
            ,alignment: .bottom
        )
        
        .padding()
    }
}

#Preview {
    Step2View(email: "zack@zack.com", password: "yaya", firstName: "Zack", lastName: "Boutchyard")
}
