//
//  EditProfileView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct EditProfileView: View {
    @State var user: User
    @Environment(\.presentationMode) var presentationMode
    @State var interestArray: [String] = []
    @State var interests: [String] = [
        "baseball",
        "football",
        "basketball",
        "tennis",
        "soccer",
        "volleyball",
        "softball"
    ]
    @Binding var isSubmitButtonPressed: Bool
    @State var handicapSelection: [Int] = Array(-5...40)
    var body: some View {
        ScrollView {
            Text("Information")
                .fontWeight(.semibold)
                .kerning(1.2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding()
            Divider()
                .padding(.horizontal)
            Section {
                VStack() {
                    Text("bio:")
                        .fontWeight(.regular)
                        .font(.callout)
                        .kerning(1.2)
                        .padding()
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.trailing)
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(lineWidth: 0.3)
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .overlay(content: {
                            VStack(alignment: .leading, spacing: 0) {
                                TextField("Say something about yourself", text: Binding(
                                    get: { self.user.bio ?? "" },
                                    set: { self.user.bio = $0 }
                                ), axis: .vertical)
                                .padding()
                                .lineLimit(5)
                                .multilineTextAlignment(.leading)
                                .frame(maxHeight: .infinity, alignment: .topLeading)
                            }
                        })
                        .fontWeight(.regular)
                        .kerning(1.2)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                }
                Divider()
                    .padding(.top)
                VStack() {
                    Text("Interests:")
                        .fontWeight(.regular)
                        .kerning(1.2)
                        .padding()
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140, maximum: 120))], alignment: .center, spacing: 25) {
                        ForEach(interests, id: \.self) { item in
                            Button(action: {
                                toggleInterest(interest: item)
                            }, label: {
                                Text(item)
                                    .frame(width: 80, height: 10)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(interestArray.contains(item) ? Color.blue : Color.gray, lineWidth: 2)
                                    )
                            })
                        }
                    }
                }
                Divider()
                    .padding(.top)
                HStack {
                    Text("Handicap:")
                        .fontWeight(.regular)
                        .kerning(1.2)
                        .padding()
                        .padding(.leading)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    Picker(selection: Binding(get: { self.user.handicap ?? nil }, set: { self.user.handicap = $0 }), label: Text("Handicap")) {
                        ForEach(handicapSelection, id: \.self) { value in
                            Text("\(value)")
                        }
                    }
                    .frame(height: 120)
                    .pickerStyle(.wheel)
                }
                Divider()
                HStack(alignment: .top) {
                    Text("Home course:")
                        .fontWeight(.regular)
                        .kerning(1.2)
                        .padding()
                        .padding(.leading)
                    Spacer()
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(lineWidth: 0.3)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .overlay(content: {
                            VStack(alignment: .leading, spacing: 0) {
                                TextField("Enter your home course", text: Binding(
                                    get: { self.user.homeCourse ?? "" },
                                    set: { self.user.homeCourse = $0 }
                                ), axis: .vertical)
                                .padding()
                                .lineLimit(5)
                                .multilineTextAlignment(.leading)
                                .frame(maxHeight: .infinity, alignment: .topLeading)
                            }
                        })
                        .padding(.trailing)
                }
                .padding(.top)
                Divider()
                    .padding(.top)
                Button(action: {
                    isSubmitButtonPressed = true
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Submit")
                })
                .buttonStyle(.borderedProminent)
                .padding(.top)
                .frame(width: 200, height: 100, alignment: .center)
            }
            .onAppear() {
                convertStringToArray()
            }
        }
    }
    func convertStringToArray() {
        if let interestsString = user.interests {
            let interests = interestsString.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
            interestArray.append(contentsOf: interests)
        }
    }
    
    func toggleInterest(interest: String) {
        if interestArray.contains(interest) {
            if let index = interestArray.firstIndex(of: interest) {
                interestArray.remove(at: index)
            }
        } else {
            interestArray.append(interest)
        }
        //        isSelected.toggle()
    }
}
//
//#Preview {
//    EditProfileView(user: User(firstName: "zack", lastName: "boutchyard", email: "zackboutchyard@gmail.com", bio: "hello there how are you", interests: "baseball, basketball, football, soccer", handicap: 3, homeCourse: "Asheboro Municipal"))
//}
