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
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
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
                fetchUser()
                isLoading = false
            }
        }
    }
    
    func fetchUser() {
        authViewModel.fetchUserDataFromFirebase() { fetchedUser in
            user = fetchedUser
        }
    }
}


