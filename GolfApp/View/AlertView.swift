//
//  AlertView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/26/23.
//

import SwiftUI

struct AlertView: View {
    @State private var user: User?
    @State private var otherUser: OtherUser?
    @ObservedObject private var authViewModel: AuthViewModel = AuthViewModel()
    @State private var isLoading: Bool = true
    @State var otherUserPendingRequest: [OtherUser] = []
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    if !otherUserPendingRequest.isEmpty {
                        ForEach(otherUserPendingRequest, id: \.id) { otherUser in
                            HStack {
                                Image(systemName: "person.fill")
                                    .scaledToFill()
                                    .foregroundStyle(.whiteOrDark)
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                                    .background {
                                        Circle().fill(Color("Gray"))
                                    }
                                VStack {
                                    Text("\(otherUser.firstName) \(otherUser.lastName) sent you a friend request")
                                        .fontWeight(.medium)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack {
                                        Button(action: {}, label: {
                                            Text("Accept")
                                        })
                                        .buttonStyle(.borderedProminent)
                                        Button(action: {}, label: {
                                            Text("Decline")
                                        })
                                        .buttonStyle(.borderedProminent)
                                    }
                                }
                                .padding([.leading, .trailing])
                            }
                            .padding()
                            Divider()
                        }
                    }
                    
                    
                    if let notifications = user?.notifications {
                        ForEach(notifications, id: \.self) { notification in
                            Button(action: {
                                // Handle button action here if needed
                            }, label: {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .scaledToFill()
                                        .foregroundStyle(.whiteOrDark)
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                        .background {
                                            Circle().fill(Color("Gray"))
                                        }
                                    VStack {
                                        Text("\(notification.userCommenting) commented saying: \(notification.text)")
                                            .fontWeight(.medium)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(notification.timeStamp.formatted(.dateTime.hour().minute()))
                                            .font(.caption2)
                                            .fontWeight(.light)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding()
                                }
                                .padding([.leading, .trailing])
                            })
                            .buttonStyle(.plain)
                        }
                    }
                    
                    Divider()
                }
            }
        }
        .onAppear {
            Task {
                await fetchUser()
                await fetchOtherUsersByRequest()
                isLoading = false
            }
        }
    }
    
    func fetchUser() async {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
        }
    }
    
    func fetchOtherUsersByRequest() async {
        if let receivedRequests = user?.receivedRequests {
            for request in receivedRequests {
                authViewModel.fetchOtherUserFromFirebase(id: request.user) { fetchedOtherUser in
                    // Check if the fetched user is not already in the array
                    if !otherUserPendingRequest.contains(where: { user in
                        return user.id == fetchedOtherUser?.id // Update with the actual property used for comparison
                    }) {
                        // Append the fetched user to the array
                        if let fetchedUser = fetchedOtherUser {
                            otherUserPendingRequest.append(fetchedUser)
                            print("fetchedUser \(fetchedUser)")
                        }
                    }
                }
            }
        }
    }
}


