//
//  LiveRoundPostView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/13/24.
//

import SwiftUI
import FirebaseAuth

struct LiveRoundPostView: View {
    @State private var isBlinking: Bool = true
    @ObservedObject var viewModel: AuthViewModel
    let index: Int
    @State var likeBtnClicked: Bool = false
    
    var body: some View {
        VStack {
            if let mainUser = viewModel.liveRoundPostUsers?.mainUser {
                blinkingLightLiveRound
                HStack {
                    getUserImage(mainUser: mainUser)
                    getLiveRoundUsers(mainUser: mainUser,
                                      otherUser: viewModel.liveRoundPostUsers?.otherUser,
                                      liveRoundFirebaseModel: viewModel.liveRounds[index])
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.top)
                getLiveRoundScore(mainUser: mainUser,
                                  otherUser: viewModel.liveRoundPostUsers?.otherUser,
                                  firebaseUserData: viewModel.liveRounds[index])
                likeOrViewRoundRow()
            }
        }
        .onAppear {
            if let likes = viewModel.liveRounds[index].likes, let uid = Auth.auth().currentUser?.uid {
                if likes.contains(uid) {
                    likeBtnClicked = true
                }
            }
        }
        .background(.whiteOrDark)
    }
    
    @ViewBuilder
    var blinkingLightLiveRound: some View {
        VStack {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 5, height: 5)
                .opacity(isBlinking ? 0 : 1)
                .foregroundStyle(.yellow)
                .animation(.easeInOut(duration: 1.5).repeatForever(), value: isBlinking)
                .onAppear {
                    self.isBlinking.toggle()
                }
        }
        .padding(.top)
    }
    
    @ViewBuilder
    func likeOrViewRoundRow() -> some View {
        Divider()
            .padding(.bottom, 5)
        HStack {
            Button(action: {
                Task {
                    likeBtnClicked.toggle()
                    if likeBtnClicked {
                         let id = viewModel.liveRounds[index].id
                        viewModel.addUserIdToLikesLiveRound(liveRoundId: id)
                    } else {
                        let id = viewModel.liveRounds[index].id
                        viewModel.removeUserIdFromLikesLiveRound(liveRoundId: id)
                    }
                }
            }, label: {
                HStack {
                    Image(systemName: "hand.thumbsup")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                    Text("Like")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                }
            })
            .foregroundStyle(likeBtnClicked ? .green : .primary)
            .buttonStyle(.plain)
            .padding(.leading, 50)
            Spacer()
            Button(action: {
            }, label: {
                HStack {
                    Image(systemName: "message")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                    Text("Comment")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                }
                .padding(.trailing, 50)
            })
            .buttonStyle(.plain)
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    func getLiveRoundScore(mainUser: OtherUser, otherUser: OtherUser?, firebaseUserData: LiveRoundFirebaseModel) -> some View {
        HStack {
            Text("\(mainUser.firstName): \(firebaseUserData.users.mainUser.score)")
            if firebaseUserData.users.mainUser.score > firebaseUserData.users.otherUser.score {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
            }
            if let otherUser {
                Text("\(otherUser.firstName): \(firebaseUserData.users.otherUser.score)")
                if firebaseUserData.users.otherUser.score > firebaseUserData.users.mainUser.score {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func getLiveRoundUsers(mainUser: OtherUser, otherUser: OtherUser?, liveRoundFirebaseModel: LiveRoundFirebaseModel) -> some View {
        if let otherUser {
            Text(mainUser.firstName).fontWeight(.bold) +
            Text(" ") +
            Text(mainUser.lastName).fontWeight(.bold) +
            Text(" is playing at \(liveRoundFirebaseModel.courseName) with ") +
            Text(otherUser.firstName).fontWeight(.bold) +
            Text(" ") +
            Text(otherUser.lastName).fontWeight(.bold)
                .kerning(1.2)
        } else {
            Text(mainUser.firstName).fontWeight(.bold) +
            Text(" ") +
            Text(mainUser.lastName).fontWeight(.bold) +
            Text(" is playing at \(liveRoundFirebaseModel.courseName)")
                .kerning(1.2)
        }
    }
    
    @ViewBuilder
    func getUserImage(mainUser: OtherUser) -> some View {
        if let data = mainUser.profilePicData, let uiImage = UIImage(data: data) {
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
    }
}
