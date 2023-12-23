//
//  ProfileView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/3/23.
//

import SwiftUI
import FirebaseDatabase
import AlertToast


struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State var user: User?
    @State private var teeTimeBtnSelected: Bool = false
    @State private var profileBtnSelected: Bool = true
    @State private var friendsListBtnSelected: Bool = false
    @State private var isEditButtonClicked = false
    @State private var isOtherViewClicked = false
    @State private var isAddFriendClicked = false
    @State var searchText: String = ""
    @State var friends: [OtherUser]?
    @State private var filteredUsers: [OtherUser]?
    @State private var isOtherUserClicked: Bool = false
    @State var otherUser: OtherUser?
    @State var image: UIImage?
    @State var isSubmitButtonPressed: Bool = false
    
    
    
    var body: some View {
        ScrollView {
                if user != nil {
                    ProfileHeadingView(user: user!, isEditButtonClicked: $isEditButtonClicked, isOtherViewTriggered: $isOtherViewClicked)
                    
                    
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
                                    friends = nil
                                    getOtherUserInfo(friendsList: user?.friendsList ?? [])
                                }, label: {
                                    Text("Friends")
                                })
                                .buttonStyle(.bordered)
                                .tint(friendsListBtnSelected ? .blue : nil)
                            } .padding(.vertical, 5)
                            
                            if profileBtnSelected {
                                if let user = user {
                                    ProfileInfoView(authViewModel: authViewModel, user: user, isOtherUserProfile: false)
                                }
                            }
                            if teeTimeBtnSelected {
                                VStack {
                                    ScoreCardView()
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
                                    Button(action: {
                                        isAddFriendClicked = true
                                    }, label: {
                                        Text("Add friend")
                                        
                                    }).buttonStyle(.borderedProminent)
                                        .padding(.trailing)
                                }
                                TextField("search friends", text: $searchText)
                                    .padding(4)
                                    .font(.system(size: 20))
                                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: .init(0.5))).padding()
                                Divider()
                                ForEach(filteredUsers ?? friends ?? [], id: \.id){ friend in
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
                                                isOtherUserClicked = true
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
                        }
                        
                    }
                }
           
            
            
        }
        .toast(isPresenting: $isSubmitButtonPressed) {
            AlertToast(displayMode: .banner(.pop), type: .complete(.green), title: "Profile updated successfully")
        }
        .navigationDestination(isPresented: $isEditButtonClicked, destination: {
            if let user = user {
                EditProfileView(user: user, isSubmitButtonPressed: $isSubmitButtonPressed)
                    .navigationTitle("Update profile")
                    .background(.whiteOrDark)
            }
        })
        .navigationDestination(isPresented: $isAddFriendClicked) {
            if let currentUser = user {
                SearchDetailView(searchText: $searchText, user: currentUser, isAddFriendView: .constant(true))
                    .toolbar(content: {
                        ToolbarItem(placement: .principal) {
                            TextField("search users", text: $searchText)
                                .padding(.leading)
                                .padding(4)
                                .font(.system(size: 20))
                                .background(RoundedRectangle(cornerRadius: 30).stroke(Color.heading, lineWidth: .init(1.0)))
                        }
                    })
            }
            
            
        }
        .navigationDestination(isPresented: $isOtherUserClicked) {
            if let otherUser = otherUser {
                if let user = user {
                    OtherUserProfileView(otherUser: otherUser, user: user)
                }
            }
        }
        .onChange(of: searchText) {
            filterUsers()
        }
    }
    
    func getOtherUserInfo(friendsList: [String]){
        authViewModel.fetchFriendsFromFirebase(ids: friendsList) { allFriends in
            friends = allFriends
        }
    }
    
    private func filterUsers() {
        if searchText != "" {
            if let allUsers = authViewModel.friendsList {
                filteredUsers = allUsers.filter { $0.firstName.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredUsers = authViewModel.friendsList
        }
    }
}



#Preview {
    ProfileView()
}
