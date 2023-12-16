//
//  OtherUserProfileView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/5/23.
//

import SwiftUI

struct OtherUserProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @State var otherUser: OtherUser
    @State var user: User
    @ObservedObject var msgViewModel: MessageViewModel = MessageViewModel()
    @State var isChatViewTriggered: Bool = false
    @State var chatId: String?
    @State var image: UIImage?
    @State var isLoading: Bool = true
    var body: some View {
        ScrollView {
            if !isLoading {
                VStack (spacing: 0){
                    VStack {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 125, height: 125)
                                .clipShape(Circle())
                                .background {
                                    Circle().fill(Color("AppGray"))
                                }
                                .padding(22)
                        }else {
                            ProfileImage(imageState: .empty)
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 125, height: 125)
                                .background {
                                    Circle().fill(Color("AppGray"))
                                }
                                .padding(22)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Image("golf-background").resizable().ignoresSafeArea())
                    HStack {
                        Spacer()
                        Text("\(otherUser.firstName) \(otherUser.lastName)")
                            .fontWeight(.light)
                            .kerning(1.2)
                            .padding(.leading)
                            .padding()
                            .lineLimit(1)
                        Spacer()
                        
                    }
                    .background(.gray)
                    HStack {
                        Spacer()
                        if user.sentRequests?.contains(where: { $0.user == otherUser.id }) == true {
                            Text("Pending approval")
                                .padding()
                        } else if ((user.friendsList?.contains(otherUser.id)) == true) {
                            Text("Friend")
                                .padding()
                        } else {
                            Button(action: {
                                //TODO: implement add friend function here
                            }, label: {
                                Text("Add friend")
                            })
                            .buttonStyle(.borderedProminent)
                            .padding()
                        }
                       
                        
                        Button(action: {
                            if let chats = user.chats {
                                for chat in chats {
                                    msgViewModel.fetchChat(chatId: chat) { fetchedChat in
                                        if fetchedChat?.participants?.contains(otherUser.id) == true {
                                            chatId = chat
                                            isChatViewTriggered = true
                                        }
                                    }
                                }
                                isChatViewTriggered = true
                            }
                        }, label: {
                            Text("Message")
                        })
                        .buttonStyle(.borderedProminent)
                        .padding()
                        Spacer()
                    }
                        ProfileInfoView(otherUser: otherUser, isOtherUserProfile: true)
                            .background(Color.whiteOrDark)
                   
                }
                .background(Color.whiteOrDark)
            } else {
                LoadingView()
            }
            
        }
        .navigationDestination(isPresented: $isChatViewTriggered) {
            if let chatId = chatId {
                ChatView(chatId: chatId, otherUser: otherUser)
            } else {
                NewChatView(otherUser: otherUser, isPresented: .constant(true))
            }
        }
        .onAppear() {
            Task {
                if let profilePic = otherUser.profilePic {
                        processOtherUserProfileImage(photoId: profilePic)
                } else {
                    isLoading = false
                }
            }
        }
    }
    func processOtherUserProfileImage(photoId: String) {
        authViewModel.fetchPhotoData(photoId: photoId) { fetchedData in
            if photoId != "" {
                if let data = fetchedData {
                    print("Downloaded photo data:", data)
                    image = UIImage(data: data)
                    isLoading = false
                } else {
                    image = nil
                    isLoading = false
                }
            } else {
                image = nil
                isLoading = false
            }
            
        }
    }
}

//#Preview {
//    OtherUserProfileView()
//}
