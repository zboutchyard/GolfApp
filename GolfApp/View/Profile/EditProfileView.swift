//
//  EditProfileView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/23/23.
//

import SwiftUI

struct EditProfileView: View {
    @State var user: User
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var interestArray: [String] = []
    @ObservedObject var searchModel = CourseSearchViewModel()
    @State private var showCourseList = false
    @State var selectedCourseName: String = ""
    @State var data: Data?
    
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
            Section {
                VStack {
                    EditableCircularProfileImage(data: $data)
                    Text("Bio:")
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
                        .padding(.bottom)
                }
                
                VStack {
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
                                    .foregroundStyle(interestArray.contains(item) ? Color.white : Color.black)
                                    .frame(width: 80, height: 10)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(interestArray.contains(item) ? Color.green.opacity(0.2) : Color.gray, lineWidth: 2)
                                            .fill(interestArray.contains(item) ? Color.green.opacity(0.2) : Color.white))
                            })
                        }
                    }
                    .padding(.bottom)
                }
                HStack {
                    Text("Handicap:")
                        .fontWeight(.regular)
                        .kerning(1.2)
                        .padding()
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Picker(selection: $user.handicap.orDefault, label: Text("Handicap")) {
                            ForEach(handicapSelection, id: \.self) { value in
                                Button {
                                    user.handicap = value
                                } label: {
                                    Text("\(value)").tag(value)
                                }

                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                }
                HStack(alignment: .top) {
                    Text("Home course:")
                        .fontWeight(.regular)
                        .kerning(1.2)
                        .padding()
                        .padding(.leading)
                    Spacer()
                    VStack {
                        if let location = searchModel.currentLocation {
                            Button(action: {
                                searchModel.searchForGolfCourses(near: location)
                                showCourseList.toggle()
                            }) {
                                if let courseName = user.homeCourse {
                                    Text(courseName.isEmpty ? "Choose a course" : selectedCourseName.isEmpty ? courseName : selectedCourseName)
                                        .opacity(0.8)
                                        .fontWeight(.regular)
                                        .kerning(1.2)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }
                            }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        } else {
                            Text("Determining your location...")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.whiteOrDark)
                    .edgesIgnoringSafeArea(.all)
                }
                .padding(.vertical)
            }
            .background(.whiteOrDark)
            RoundedCorner(radius: 50, corners: .allCorners)
                .fill(.green)
                .frame(height: 50)
                .foregroundStyle(.whiteOrBlack)
                .overlay {
                    Button {
                        user.interests = interestArray.joined(separator: ",")
                        authViewModel.saveUserData(user: user, profilePicData: data) { _, _ in
                            isSubmitButtonPressed = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Submit")
                            .fontWeight(.medium)
                            .font(.title2)
                            .kerning(0.8)
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundStyle(.white)
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
                .onAppear {
                    convertStringToArray()
                }
        }
        .backButtonToolbar()
        .navigationBarBackButtonHidden()
        .navigationTitle("Update profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCourseList) {
            switch searchModel.state {
            case .loading:
                VStack {
                    LoadingView()
                }
            case .loaded:
                VStack {
                    if searchModel.locationResult.isEmpty {
                        Text("No courses found, please change your location and try again.")
                    } else {
                        VStack {
                            ForEach(searchModel.locationResult, id: \.name) { course in
                                VStack {
                                    Button {
                                        user.homeCourse = course.name
                                        selectedCourseName = course.name
                                        showCourseList = false
                                    } label: {
                                        Text(course.name)
                                    }
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .buttonStyle(.plain)
                                    .padding()
                                }
                                Divider()
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top)
                    }
                }
            case .error:
                Text("An error occurred. Please try again later.")
            }
        }
        .presentationDetents([.height(400)])
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

extension Optional where Wrapped == Int {
    var orDefault: Int {
        get { self ?? 0 } // Provide a default value for the binding
        set { self = newValue }
    }
}
