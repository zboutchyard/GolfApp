//
//  SearchDetailView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/24/23.
//

import SwiftUI
import AlertToast

struct SearchDetailView: View {
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @Binding var searchText: String
    @State var user: User?
    @State private var filteredUsers: [OtherUser]?
    @State var isAddFriendSelected: Bool = false
    @Binding var isAddFriendView: Bool
    @ObservedObject var notificationViewModel: NotificationViewModel = NotificationViewModel()
    @State var selectedUser: OtherUser?
    @State var isUserSelected: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Users")
                    .fontWeight(.semibold)
                    .font(.title3)
                    .kerning(1.2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Divider()
                
                if let users = filteredUsers, !users.isEmpty {
                    ForEach(users, id: \.id) { otherUser in
                        HStack {
                            Button(action: {
                                selectedUser = otherUser
                                isUserSelected = true
                            }, label: {
                                PersonCellView(otherUser: otherUser, isPostView: .constant(false))
                            })
                            .buttonStyle(.plain)
                            if isAddFriendView == true {
                                if let sentRequests = user?.sentRequests, let receivedRequests = user?.receivedRequests,
                                   sentRequests.contains(where: { $0.user == otherUser.id }) || receivedRequests.contains(where: { $0.user == otherUser.id }) {
                                    Button(action: {
                                    }, label: {
                                        Text("Pending approval")
                                    })
                                    .disabled(true)
                                } else if ((user?.friendsList?.contains(otherUser.id)) != nil){
                                    Button(action: {
                                    }, label: {
                                        Text("Friends")
                                    })
                                    .disabled(true)
                                } else {
                                    Button(action: {
                                        notificationViewModel.sendRequest(userId: otherUser.id)
                                        fetchCurrentUser()
                                        isAddFriendSelected = true
                                    }, label: {
                                        Text("Add")
                                    })
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                            if isAddFriendView == false {
                                Spacer()
                            }
                        }
                        
                    }
                } else {
                    ProgressView()
                }
            }
        }
        .navigationDestination(isPresented: $isUserSelected, destination: {
            if let selectedUser = selectedUser {
                OtherUserProfileView(otherUser: selectedUser, user: user)
            }
            
        })
        .toast(isPresenting: $isAddFriendSelected, alert: {
            AlertToast(displayMode: .banner(.pop), type: .complete(.mint), title: "Request sent")
        })
        .onAppear() {
            fetchOtherUsers()
        }
        .onChange(of: searchText) {
            filterUsers()
        }
    }
    
    private func fetchOtherUsers() {
        authViewModel.fetchAllOtherUsersFromFirebase() { users in
            if let users = users {
                filteredUsers = users
            }
        }
    }
    
    private func fetchCurrentUser() {
        authViewModel.fetchUserDataFromFirebase { fetchedUser in
            user = fetchedUser
        }
    }
    
    private func filterUsers() {
        if searchText != "" {
            if let allUsers = authViewModel.otherUsers {
                filteredUsers = allUsers.filter { $0.firstName.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredUsers = authViewModel.otherUsers
        }
        
    }
}


//#Preview {
//    SearchDetailView(searchText: "")
//}
