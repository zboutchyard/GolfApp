//
//  TeeTimeView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/22/23.
//

import SwiftUI

struct ScoreCardView: View {
    @State var user: User?
    @State var courseName: String = ""
    @State private var selectedHoles: Int = 18 // Add this state to track selected holes
    @State var isShareRoundSelected: Bool = false
    @State var isPopoverActivated: Bool = false
    @State private var isExpanded: Bool = false
    @State var postText: String = ""
    @State var isTeeSelectorClicked: Bool = false
    @State var isAddPlayerClicked: Bool = false
    @State var choosePlayerClicked: Bool = false
    @State var otherUser: OtherUser?
    @State var friends: [OtherUser]?
    @State var searchText: String = ""
    @State private var filteredUsers: [OtherUser]?
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @StateObject var searchModel = CourseSearchViewModel()
    @State var shouldCloseSearch: Bool = false
    @State var selectedCourseName: String = ""
    @State var isCourseSheetPresented: Bool = false
    @State private var showCourseList = false
    
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    ScrollView {
                        HStack {
                            Image(systemName: "person.fill")
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .background {
                                    Circle().fill(Color("AppGray"))
                                }
                                .foregroundStyle(.whiteOrDark)
                            Text("Zack Boutchyard")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 3)
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                        }
                        .padding(.leading, 5)
                        
                        Button {
                            isAddPlayerClicked = true
                        } label: {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Text("Add player")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                        
                        VStack {
                            if let location = searchModel.currentLocation {
                                Button(action: {
                                    searchModel.searchForGolfCourses(near: location)
                                    showCourseList.toggle()
                                }) {
                                    Text(selectedCourseName.isEmpty ? "Choose a course" : selectedCourseName)
                                        .opacity(selectedCourseName.isEmpty ? 0.8 : 1.0)
                                        .font(.title2)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
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
                        
                        
                        VStack {
                            Button {
                                isTeeSelectorClicked = true
                            } label: {
                                HStack {
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.blue)
                                    Text("Blue")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                        .kerning(0.8)
                                    
                                }
                                .padding()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        }
                        .background(.whiteOrDark)
                        VStack {
                            HStack {
                                Text("How many holes?")
                                    .fontWeight(.medium)
                                    .font(.title2)
                                    .kerning(0.8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .cornerRadius(50, corners: .allCorners)
                                
                                ZStack {
                                    HStack(spacing: 1) {
                                        RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft])
                                            .fill(selectedHoles == 9 ? Color.blue : Color.gray.opacity(0.2))
                                            .frame(height: 50)
                                            .overlay {
                                                Button {
                                                    selectedHoles = 9
                                                } label: {
                                                    Text("9")
                                                }
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .foregroundColor(selectedHoles == 9 ? .white : .blue)
                                            }
                                        RoundedCorner(radius: 20, corners: [.topRight, .bottomRight])
                                            .fill(selectedHoles == 18 ? Color.blue : Color.gray.opacity(0.2))
                                            .frame(height: 50)
                                            .overlay {
                                                Button {
                                                    selectedHoles = 18
                                                } label: {
                                                    Text("18")
                                                }
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .foregroundColor(selectedHoles == 18 ? .white : .blue)
                                            }
                                    }
                                }
                                .frame(height: 50)
                                .cornerRadius(20)
                                .padding()
                            }
                        }
                        .background(.whiteOrDark)
                        VStack {
                            HStack {
                                Button {
                                    isPopoverActivated = true
                                } label: {
                                    Image(systemName: "questionmark.circle.fill")
                                }
                                
                                Toggle(
                                    "Start live round",
                                    isOn: $isShareRoundSelected
                                )
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                                .onChange(of: isShareRoundSelected) {
                                    withAnimation {
                                        isExpanded.toggle()
                                    }
                                }
                            }
                            .padding()
                            if isExpanded {
                                Divider()
                                VStack {
                                    TextField("...What do you want to say?", text: $postText)
                                        .scrollContentBackground(.hidden)
                                        .frame(height: 400, alignment: .top)
                                        .background(Color.whiteOrDark)
                                        .transition(.slide)
                                        .animation(.easeInOut, value: isExpanded)
                                }
                                .background(.whiteOrDark)
                            }
                        }
                        .background(.whiteOrDark)
                    }
                }
            }
            Spacer()
            VStack {
                RoundedCorner(radius: 50, corners: .allCorners)
                    .fill(.green)
                    .frame(height: 50)
                    .overlay {
                        Button {
                            //
                        } label: {
                            Text("Start round")
                                .fontWeight(.medium)
                                .font(.title2)
                                .kerning(0.8)
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundStyle(.white)
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                
            }
            .padding(.horizontal)
            .padding(.bottom)
            .frame(alignment: .bottom)
            .popover(isPresented: $isPopoverActivated ,
                     attachmentAnchor: .point(.center),
                     arrowEdge: .top,
                     content: {
                PopoverScoreCardView()
                    .padding()
                    .presentationCompactAdaptation(.automatic)
                
            })
            
            .padding(.top)
            //        .onTapGesture {
            //                hideKeyboard()
            //        }
            .sheet(isPresented: $isAddPlayerClicked) {
                VStack {
                    TextField("search friends", text: $searchText)
                        .padding(4)
                        .font(.system(size: 20))
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: .init(0.5))).padding()
                    Divider()
                    ForEach(filteredUsers ?? authViewModel.friendsList ?? [], id: \.id){ friend in
                        HStack {
                            if let data = friend.profilePicData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .background {
                                        Circle().fill(Color("AppGray"))
                                    }
                                    .foregroundStyle(.whiteOrDark)
                            } else {
                                Image(systemName: "person.fill")
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                                    .background {
                                        Circle().fill(Color("AppGray"))
                                    }
                                    .foregroundStyle(.whiteOrDark)
                            }
                            
                            
                            VStack {
                                Button {
                                    otherUser = friend
                                    choosePlayerClicked = true
                                } label: {
                                    Text("\(friend.firstName) \(friend.lastName)")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(.plain)
                                .padding()
                                
                            }
                            Spacer()
                        }
                        
                        
                        
                        Divider()
                    }
                }
                .onChange(of: searchText) {
                    filterUsers()
                }
                .padding(.top)
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
                .presentationDetents([.height(400)])
                
            }
            
            .sheet(isPresented: $showCourseList) {
                VStack {
                    if searchModel.locationResult.isEmpty {
                        Text("Fetching nearby golf courses...")
                    } else {
                        VStack {
                            List(searchModel.locationResult, id: \.self) { completion in
                                Button {
                                    selectedCourseName = completion.title
                                    showCourseList = false
                                } label: {
                                    Text(completion.title)
                                }
                                .buttonStyle(.plain)

                                // When you select a course, you can perform further actions here
                            }
                        }
                    }
                }
                
            }
            
            .sheet(isPresented: $isTeeSelectorClicked) {
                VStack {
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.black)
                                Text("Black")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fontWeight(.medium)
                                    .font(.title2)
                                    .kerning(0.8)
                            }
                            .padding()
                        }
                        .buttonStyle(.plain)
                    }
                    .background(.whiteOrDark)
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.blue)
                                Text("Blue")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fontWeight(.medium)
                                    .font(.title2)
                                    .kerning(0.8)
                            }
                            .padding()
                        }
                        .buttonStyle(.plain)
                    }
                    .background(.whiteOrDark)
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.white)
                                Text("White")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fontWeight(.medium)
                                    .font(.title2)
                                    .kerning(0.8)
                            }
                            .padding()
                        }
                        .buttonStyle(.plain)
                    }
                    .background(.whiteOrDark)
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.yellow)
                                Text("Yellow")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fontWeight(.medium)
                                    .font(.title2)
                                    .kerning(0.8)
                            }
                            .padding()
                        }
                        .buttonStyle(.plain)
                    }
                    .background(.whiteOrDark)
                    HStack {
                        Button {
                            //
                        } label: {
                            HStack {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.red)
                                Text("Red")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fontWeight(.medium)
                                    .font(.title2)
                                    .kerning(0.8)
                            }
                            .padding()
                        }
                        .buttonStyle(.plain)
                    }
                    .background(.whiteOrDark)
                }
                .padding(.top)
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
            }
            
            
            
            
            
        }
        
        
    }
    func filterUsers() {
        if searchText != "" {
            if let allUsers = authViewModel.friendsList {
                filteredUsers = allUsers.filter { $0.firstName.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredUsers = authViewModel.friendsList
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

#Preview {
    ScoreCardView()
}
