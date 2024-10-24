//
//  AlertView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/26/23.
//

import SwiftUI
import AlertToast
import FirebaseAuth

struct AlertView: View {
    @State private var otherUser: OtherUser?
    @StateObject var authViewModel: AuthViewModel
    @StateObject var notificationViewModel: NotificationViewModel
    @StateObject var msgViewModel: MessageViewModel
    @State var isRequestAccepted: Bool = false
    @State var isRequestDeclined: Bool = false
    @State var isNotificationClicked: Bool = false
    @State var selectedPost: Post?

    var body: some View {
        VStack {
            if authViewModel.otherUserPendingRequest.isEmpty && ((authViewModel.user?.notifications == nil)) {
                    VStack {
                        Spacer()
                        Image(systemName: "bell.slash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 125, height: 125)
                        Text("You don't have any notifications yet")
                            .fontWeight(.light)
                            .kerning(1.2)
                            .padding()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        if !authViewModel.otherUserPendingRequest.isEmpty {
                            ForEach(authViewModel.otherUserPendingRequest, id: \.id) { otherUser in
                                HStack {
                                    if let data = otherUser.profilePicData, let uiImage = UIImage(data: data) {
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
                                        Text("\(otherUser.firstName) \(otherUser.lastName) sent you a friend request")
                                            .fontWeight(.medium)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        HStack {
                                            Button(action: {
                                                Task {
                                                    notificationViewModel.addFriend(userId: otherUser.id)
                                                    notificationViewModel.removePendingRequests(userId: otherUser.id)
                                                    authViewModel.otherUserPendingRequest.removeAll()
                                                    isRequestAccepted = true
                                                }
                                            }, label: {
                                                Text("Accept")
                                            })
                                            .buttonStyle(.borderedProminent)
                                            Button(action: {
                                                Task {
                                                    notificationViewModel.removePendingRequests(userId: otherUser.id)
                                                    authViewModel.otherUserPendingRequest.removeAll()
                                                    isRequestDeclined = true
                                                }

                                            }, label: {
                                                Text("Decline")
                                            })
                                            .buttonStyle(.borderedProminent)
                                        }
                                        .background(.whiteOrDark)

                                    }
                                    .padding()
                                }
                                .padding()
                                Divider()
                            }

                        }
                        if let notifications = authViewModel.user?.notifications, !notifications.isEmpty {
                            let sortedNotifications = notifications.sorted { (first, second) -> Bool in
                                return !first.hasBeenRead && second.hasBeenRead
                            }
                            VStack(spacing: 3) {
                            ForEach(sortedNotifications, id: \.self) { notification in
                                    Button(action: {
                                        if !notification.hasBeenRead {
                                            authViewModel.updateNotificationToRead(notificationId: notification.id)
                                        }
                                        authViewModel.fetchPostFromFirebase(postId: notification.postId) { fetchedPost in
                                            selectedPost = fetchedPost
                                            isNotificationClicked = true
                                        }
                                    }, label: {
                                        HStack {
                                            if let data = authViewModel.otherUserNotifications[notification.userCommenting]?.profilePicData,
                                                let uiImage = UIImage(data: data) {
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
                                                // swiftlint:disable:next line_length
                                                Text("\(authViewModel.otherUserNotifications[notification.userCommenting]?.firstName ?? "") \(authViewModel.otherUserNotifications[notification.userCommenting]?.lastName ?? "") commented saying: \(notification.text)")
                                                    .fontWeight(.semibold)
                                                    .frame(maxWidth: .infinity, alignment: .leading)

                                                Text(notification.timeStamp.formatted(.dateTime.hour().minute()))
                                                    .font(.caption2)
                                                    .fontWeight(.light)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .padding()
                                        }
                                        .padding(3)
                                        .background(!notification.hasBeenRead ? Color.whiteOrGray : Color.lightGrayOrDark)
                                    })
                                    .frame(maxWidth: .infinity)
                                    .buttonStyle(.plain)
                                }
                            }
                        } else {
                            Text("No notifications")
                        }
                    }
                }

        }

        .background(.whiteOrBlack)
        .toast(isPresenting: $isRequestAccepted) {
            AlertToast(displayMode: .banner(.slide), type: .systemImage("checkmark", Color("Green")), title: "Request approved")
        }
        .toast(isPresenting: $isRequestDeclined) {
            AlertToast(displayMode: .banner(.slide), type: .systemImage("x", Color("Green")), title: "Request declined")
        }
        .navigationDestination(isPresented: $isNotificationClicked) {
            if let user = authViewModel.user {
                PostDetailView(post: selectedPost,
                               authViewModel: authViewModel,
                               notificationViewModel: notificationViewModel,
                               msgViewModel: msgViewModel,
                               user: user,
                               otherUser: otherUser)

            }
        }

    }
}
// #Preview {
//    AlertView()
// }
