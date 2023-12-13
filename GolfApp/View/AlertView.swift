//
//  AlertView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/26/23.
//

import SwiftUI
import AlertToast

struct AlertView: View {
    @State private var user: User?
    @State private var otherUser: OtherUser?
    @ObservedObject private var authViewModel: AuthViewModel = AuthViewModel()
    @State private var isLoading: Bool = true
    @ObservedObject private var notificationViewModel: NotificationViewModel = NotificationViewModel()
    @State var otherUserPendingRequest: [OtherUser] = []
    @State var isRequestAccepted: Bool = false
    @State var isRequestDeclined: Bool = false
    @State var otherUserNotification: OtherUser?
    @State private var otherUserNotifications: [String: OtherUser] = [:]
    
    
    
    var body: some View {
        ScrollView {
            if !isLoading {
                if !otherUserPendingRequest.isEmpty {
                    ForEach(otherUserPendingRequest, id: \.id) { otherUser in
                        HStack {
                            Image(systemName: "person.fill")
                                .scaledToFill()
                                .foregroundStyle(.whiteOrDark)
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .background {
                                    Circle().fill(Color("AppGray"))
                                }
                            VStack {
                                Text("\(otherUser.firstName) \(otherUser.lastName) sent you a friend request")
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                HStack {
                                    Button(action: {
                                        Task {
                                            notificationViewModel.addFriend(userId: otherUser.id)
                                            notificationViewModel.removePendingRequests(userId: otherUser.id)
                                            otherUserPendingRequest.removeAll()
                                            await fetchUser()
                                            isRequestAccepted = true
                                        }
                                    }, label: {
                                        Text("Accept")
                                    })
                                    .buttonStyle(.borderedProminent)
                                    Button(action: {
                                        Task {
                                            notificationViewModel.removePendingRequests(userId: otherUser.id)
                                            otherUserPendingRequest.removeAll()
                                            await fetchUser()
                                            isRequestDeclined = true
                                        }
                                        
                                    }, label: {
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
                            
                        }, label: {
                            HStack {
                                Image(systemName: "person.fill")
                                    .scaledToFill()
                                    .foregroundStyle(.whiteOrDark)
                                    .clipShape(Circle())
                                    .frame(width: 50, height: 50)
                                    .background {
                                        Circle().fill(Color("AppGray"))
                                    }
                                
                                VStack {
                                    Text("\(otherUserNotifications[notification.userCommenting]?.firstName ?? "") \(otherUserNotifications[notification.userCommenting]?.lastName ?? "") commented saying: \(notification.text)")
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
                        Divider()
                    }
                    .onAppear {
                        Task {
                            for notification in notifications {
                                await fetchUserInfoById(userId: notification.userCommenting)
                            }
                        }
                    }
                }
            } else {
                LoadingView()
            }
        }
        .background(.whiteOrDark)
        .onAppear {
            Task {
                await fetchUser()
                isLoading = false
            }
        }
        .toast(isPresenting: $isRequestAccepted) {
            AlertToast(displayMode: .banner(.slide), type: .systemImage("checkmark", Color("Green")), title: "Request approved")
        }
        .toast(isPresenting: $isRequestDeclined) {
            AlertToast(displayMode: .banner(.slide), type: .systemImage("x", Color("Green")), title: "Request declined")
        }
        
        
    }
    
    func fetchUser() async {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
            if user?.receivedRequests != nil {
                fetchOtherUsersByRequest()
            }
        }
    }
    
    func fetchOtherUsersByRequest() {
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
                        }
                    }
                }
            }
        }
    }
    
    func fetchUserInfoById(userId: String) async {
        authViewModel.fetchOtherUserFromFirebase(id: userId) { fetchedOtherUser in
            otherUserNotifications[userId] = fetchedOtherUser
        }
    }
}


