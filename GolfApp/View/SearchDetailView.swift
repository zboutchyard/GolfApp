//
//  SearchDetailView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/24/23.
//

import SwiftUI
import AlertToast

struct SearchDetailView: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var msgViewModel: MessageViewModel
    @Binding var searchText: String
    @State private var filteredUsers: [OtherUser]?
    @State var isAddFriendSelected: Bool = false
    @Binding var isAddFriendView: Bool
    @StateObject var notificationViewModel: NotificationViewModel
    @State var selectedUser: OtherUser?
    @State var isUserSelected: Bool = false
    @State var isLoading: Bool = false
    
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
                
                    ForEach(filteredUsers ?? authViewModel.otherUsers ?? [], id: \.id) { otherUser in
                        HStack {
                            Button(action: {
                                selectedUser = otherUser
                                isUserSelected = true
                            }, label: {
                                PersonCellView(otherUser: otherUser, authViewModel: authViewModel, isPostView: .constant(false))
                            })
                            .buttonStyle(.plain)
                            if isAddFriendView == true {
                                if let sentRequests = authViewModel.user?.sentRequests, let receivedRequests = authViewModel.user?.receivedRequests,
                                   sentRequests.contains(where: { $0.user == otherUser.id }) || receivedRequests.contains(where: { $0.user == otherUser.id }) {
                                    Button(action: {
                                    }, label: {
                                        Text("Pending approval")
                                    })
                                    .disabled(true)
                                } else if (authViewModel.user?.friendsList?.contains(otherUser.id)) == true {
                                    Button(action: {
                                    }, label: {
                                        Text("Friends")
                                    })
                                    .disabled(true)
                                } else {
                                    Button(action: {
                                        notificationViewModel.sendRequest(userId: otherUser.id)
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
            }
        }
        .navigationDestination(isPresented: $isUserSelected, destination: {
            if let selectedUser = selectedUser {
                if let user = authViewModel.user {
                    OtherUserProfileView(authViewModel: authViewModel,
                                         notificationViewModel: notificationViewModel,
                                         otherUser: selectedUser,
                                         user: user,
                                         msgViewModel: msgViewModel)
                }
            }
        })
        .toast(isPresenting: $isAddFriendSelected, alert: {
            AlertToast(displayMode: .banner(.pop), type: .complete(.mint), title: "Request sent")
        })
        .onChange(of: searchText) {
            filterUsers()
        }
    }
    
    private func filterUsers() {
        if !searchText.isEmpty {
            if let allUsers = authViewModel.otherUsers {
                filteredUsers = allUsers.filter { $0.firstName.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            filteredUsers = authViewModel.otherUsers
        }
        
    }
}

// #Preview {
//    SearchDetailView(searchText: "")
// }
