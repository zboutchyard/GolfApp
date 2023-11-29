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
    @State private var filteredUsers: [OtherUser]?
    @State var isAddFriendSelected: Bool = false
    @Binding var isAddFriendView: Bool
    
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
                                //do something
                            }, label: {
                                PersonCellView(otherUser: otherUser, isPostView: .constant(false))
                            })
                            .buttonStyle(.plain)
                            if isAddFriendView == true {
                                Button(action: {
                                    isAddFriendSelected = true
                                }, label: {
                                    Text("Add")
                                })
                                .buttonStyle(.borderedProminent)
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
