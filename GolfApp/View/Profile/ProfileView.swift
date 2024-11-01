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
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel
    @ObservedObject var msgViewModel: MessageViewModel
    @State private var badgeViewBtnSelected: Bool = false
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
    @State var isLoading: Bool = false
    @State var shouldShowMoreOptionsView: Bool = false
    
    var body: some View {
        if isLoading {
            ProgressView()
                .background(Color.whiteOrBlack)
        } else {
            ScrollView {
                if let user = authViewModel.user {
                    ProfileHeadingView(user: user,
                                       isEditButtonClicked: $isEditButtonClicked,
                                       isOtherViewTriggered: $isOtherViewClicked,
                                       authViewModel: authViewModel)
                        if !isEditButtonClicked {
                            VStack {
                                HStack {
                                    Button(action: {
                                        isOtherViewClicked = false
                                        profileBtnSelected = true
                                        badgeViewBtnSelected = false
                                        friendsListBtnSelected = false
                                    }, label: {
                                        Text("Profile")
                                    })
                                    .buttonStyle(.bordered)
                                    .tint(profileBtnSelected ? .green : .gray)
                                    Button(action: {
                                        badgeViewBtnSelected = true
                                        profileBtnSelected = false
                                        friendsListBtnSelected = false
                                        isOtherViewClicked = true
                                    }, label: {
                                        Text("Badges")
                                    })
                                    .buttonStyle(.bordered)
                                    .tint(badgeViewBtnSelected ? .green : .gray)
                                    Button(action: {
                                        badgeViewBtnSelected = false
                                        profileBtnSelected = false
                                        friendsListBtnSelected = true
                                        isOtherViewClicked = true
                                    }, label: {
                                        Text("Friends")
                                    })
                                    .buttonStyle(.bordered)
                                    .tint(friendsListBtnSelected ? .green : .gray)
                                } .padding(.vertical, 5)
                                
                                if profileBtnSelected {
                                    if let user = authViewModel.user {
                                        ProfileInfoView(authViewModel: authViewModel,
                                                        notificationViewModel: notificationViewModel,
                                                        msgViewModel: msgViewModel,
                                                        user: user,
                                                        isOtherUserProfile: false)
                                    }
                                }
                                if badgeViewBtnSelected {
                                    VStack {
                                        Text("Under Construction")
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
                                            
                                        })
                                        .buttonStyle(.borderedProminent)
                                        .padding(.trailing)
                                        .tint(.green)
                                    }
                                    TextField("search friends", text: $searchText)
                                        .padding(4)
                                        .font(.system(size: 20))
                                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: .init(0.5))).padding()
                                    Divider()
                                    ForEach(filteredUsers ?? authViewModel.friendsList ?? [], id: \.id) { friend in
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
                            .onChange(of: isSubmitButtonPressed) {
                                isLoading = true
                                authViewModel.fetchUserDataFromFirebase { fetchedUser in
                                    authViewModel.user = fetchedUser
                                    isLoading = false
                                }
                            }
                            
                        }
                           
                    }
                    
            }
            .toast(isPresenting: $isSubmitButtonPressed) {
                AlertToast(displayMode: .banner(.pop), type: .complete(.green), title: "Profile updated successfully")
            }
            .navigationDestination(isPresented: $isEditButtonClicked, destination: {
                if let user = authViewModel.user {
                    EditProfileView(user: user, authViewModel: authViewModel, isSubmitButtonPressed: $isSubmitButtonPressed)
                }
            })
            .navigationDestination(isPresented: $isAddFriendClicked) {
                    SearchDetailView(
                        authViewModel: authViewModel,
                        msgViewModel: msgViewModel,
                        searchText: $searchText,
                        isAddFriendView: .constant(true),
                        notificationViewModel: notificationViewModel)
                        .toolbar(content: {
                            ToolbarItem(placement: .principal) {
                                TextField("search users", text: $searchText)
                                    .padding(.leading)
                                    .padding(4)
                                    .font(.system(size: 20))
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.heading, lineWidth: .init(1.0)))
                            }
                        })
            }
            .navigationDestination(isPresented: $isOtherUserClicked) {
                if let otherUser = otherUser {
                    if let user = authViewModel.user {
                        OtherUserProfileView(authViewModel: authViewModel,
                                             notificationViewModel: notificationViewModel,
                                             otherUser: otherUser,
                                             user: user,
                                             msgViewModel: msgViewModel)
                    }
                }
            }
            .onChange(of: searchText) {
                filterUsers()
            }
        }
    }
    
    private func filterUsers() {
        if !searchText.isEmpty {
            if let allUsers = authViewModel.friendsList {
                filteredUsers = allUsers.filter { $0.firstName.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredUsers = authViewModel.friendsList
        }
    }
}
