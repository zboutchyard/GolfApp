//
//  LandingView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseDatabase

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State private var user: User?
    @State private var teeTimeBtnSelected: Bool = false
    @State private var profileBtnSelected: Bool = true
    @State private var friendsListBtnSelected: Bool = false
    @State private var isLoading: Bool = true
    @State private var isEditButtonClicked = false
    @State private var isOtherViewClicked = false
    @State private var isAddFriendClicked = false
    @State var searchText: String = ""
    @State var friends: [OtherUser] = []
    @State private var filteredUsers: [OtherUser]?
    let coverPhotoUrl = URL(string: "https://i.pinimg.com/564x/5e/2c/65/5e2c653bfbf2d681fa39358aa4132f9e.jpg")
    let userPhotoUrl = URL(string: "https://images.unsplash.com/photo-1629747490241-624f07d70e1e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cG9ydHJhaXRzfGVufDB8fDB8fHww")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ProfileHeadingView(isEditButtonClicked: $isEditButtonClicked, isOtherViewTriggered: $isOtherViewClicked)
                if !isEditButtonClicked {
                    VStack {
                        HStack {
                            Button(action: {
                                isOtherViewClicked = false
                                profileBtnSelected = true
                                teeTimeBtnSelected = false
                                friendsListBtnSelected = false
                            }, label: {
                                Text("Profile")
                            })
                            .buttonStyle(.bordered)
                            .tint(profileBtnSelected ? .blue : nil)
                            Button(action: {
                                teeTimeBtnSelected = true
                                profileBtnSelected = false
                                friendsListBtnSelected = false
                                isOtherViewClicked = true
                            }, label: {
                                Text("Tee Time")
                            })
                            .buttonStyle(.bordered)
                            .tint(teeTimeBtnSelected ? .blue : nil)
                            Button(action: {
                                teeTimeBtnSelected = false
                                profileBtnSelected = false
                                friendsListBtnSelected = true
                                isOtherViewClicked = true
                                friends.removeAll()
                                getOtherUserInfo(friendsList: user?.friendsList ?? [])
                            }, label: {
                                Text("Friends")
                            })
                            .buttonStyle(.bordered)
                            .tint(friendsListBtnSelected ? .blue : nil)
                        } .padding(.vertical, 5)
                        
                        if profileBtnSelected {
                            ProfileInfoView()
                        }
                        if teeTimeBtnSelected {
                            VStack {
                                Text("Some text about tee times...")
                            }
                        }
                        
                        if friendsListBtnSelected {
                            Divider()
                            HStack {
                                Text("Your friends")
                                    .kerning(1.0)
                                    .fontWeight(.semibold)
                                    .padding(.leading)
                                Spacer()
                                Button(action: {}, label: {
                                    Text("Add friend")
                                    
                                }).buttonStyle(.borderedProminent)
                                    .padding(.trailing)
                            }
                            TextField("search friends", text: $searchText)
                                .padding(4)
                                .font(.system(size: 20))
                                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: .init(0.5))).padding()
                            Divider()
                            ForEach(filteredUsers ?? friends, id: \.id){ friend in
                                HStack {
                                    Image(systemName: "person.fill")
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                        .background {
                                            Circle().fill(Color("Gray"))
                                        }
                                    VStack {
                                        Button {
                                           isAddFriendClicked = true
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
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
            if isEditButtonClicked {
                EditProfileView()
            }
            
        }
        
        
        
        
        .onAppear(){
            fetchData()
            isLoading = false
        }
        .onChange(of: searchText) {
            filterUsers()
        }
    }
    
    func fetchData() {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
        }
    }
    
    
    
    func getOtherUserInfo(friendsList: [String]){
        for friend in friendsList {
            authViewModel.fetchOtherUserFromFirebase(id: friend){ friend in
                if let friend = friend {
                    friends.append(friend)
                }
                
            }
        }
    }
    
    private func filterUsers() {
        if searchText != "" {
            if let allUsers = authViewModel.otherUsers {
                filteredUsers = allUsers.filter { $0.firstName.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredUsers = nil
        }
        
    }
}

#Preview {
    ProfileView()
}
