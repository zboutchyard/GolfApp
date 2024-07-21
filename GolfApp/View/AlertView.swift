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
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @ObservedObject private var notificationViewModel: NotificationViewModel = NotificationViewModel()
    @State var otherUserPendingRequest: [OtherUser]
    @State var isRequestAccepted: Bool = false
    @State var isRequestDeclined: Bool = false
    @State var otherUserNotification: OtherUser?
    @State var otherUserNotifications: [String: OtherUser]
    @State var isNotificationClicked: Bool = false
    @State var selectedPost: Post?

    var body: some View {
        VStack {
            if otherUserPendingRequest.isEmpty && ((authViewModel.user?.notifications == nil)) {
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
                        if !otherUserPendingRequest.isEmpty {
                            ForEach(otherUserPendingRequest, id: \.id) { otherUser in
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
                                                    otherUserPendingRequest.removeAll()
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
                        if let notifications = authViewModel.user?.notifications {
                            VStack(spacing: 3) {
                            ForEach(notifications, id: \.self) { notification in
                                    Button(action: {
                                        authViewModel.fetchPostFromFirebase(postId: notification.postId) { fetchedPost in
                                            selectedPost = fetchedPost
                                            isNotificationClicked = true
                                        }
                                    }, label: {
                                        HStack {
                                            if let data = otherUserNotifications[notification.userCommenting]?.profilePicData, 
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
                                                Text("\(otherUserNotifications[notification.userCommenting]?.firstName ?? "") \(otherUserNotifications[notification.userCommenting]?.lastName ?? "") commented saying: \(notification.text)")
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
                                        .background(.whiteOrDark)
                                    })
                                    .frame(maxWidth: .infinity)
                                    .buttonStyle(.plain)
                                }
                            }
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
                PostDetailView(post: selectedPost, user: user, otherUser: otherUser)

            }
        }

    }
}
// #Preview {
//    AlertView()
// }
