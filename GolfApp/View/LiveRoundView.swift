//
//  LiveRoundView.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 1/9/24.
//

import SwiftUI

struct LiveRoundView: View {
    @State var score: Int = 0
    @FocusState var isTextFieldFocused: Bool
    @State var likeBtnClicked: Bool = false
    @State var isDismissClicked: Bool = false
    @StateObject var liveRoundViewModel: LiveRoundViewModel
    @Environment(\.dismiss) var dismiss
    @State var presentationDetent: PresentationDetent = .height(200)
    @State private var isSheetPresented: Bool = false
    @ObservedObject var liveRoundManager: LiveRoundManager
    
    init(liveRoundViewModel: LiveRoundViewModel, liveRoundManager: LiveRoundManager) {
        _liveRoundViewModel = StateObject(wrappedValue: liveRoundViewModel)
        _liveRoundManager = ObservedObject(wrappedValue: liveRoundManager)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                courseNameView
                topHoleView
                scoreAndPuttView
                currentScoreView
                messageView
                chatView
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Hole \(liveRoundViewModel.currentHole)")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.whiteOrDark)
        .alert(isPresented: $isDismissClicked) {
            Alert(title: Text("Exit live round"),
                  message: Text("Are you sure you want to exit the live round?"),
                  primaryButton: .cancel(Text("Cancel")),
                  secondaryButton: .destructive(Text("Confirm")) {
                dismiss()
            }
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    Task {
                        await liveRoundManager.cancelAllRunningActivities()
                        isDismissClicked.toggle()
                    }
                }) {
                    Image(systemName: "xmark")
                        .padding(10)
                        .frame(width: 28, height: 28)
                }
            }
        }
    }
    
    @ViewBuilder
    var messageView: some View {
        MessageToolbarLiveRoundView(isTextFieldFocused: _isTextFieldFocused)
        Divider()
            .padding(.bottom, 5)
    }
    
    @ViewBuilder
    var chatView: some View {
        ScrollView {
            HStack {
                Image(systemName: "person.fill")
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    .background {
                        Circle().fill(Color("AppGray"))
                    }
                    .foregroundStyle(.whiteOrDark)
                
                VStack {
                    Text("Jane Mary")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Hey there!")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            Divider()
        }
    }
    
    @ViewBuilder
    var courseNameView: some View {
        HStack {
            Text("\(liveRoundViewModel.selectedCourseName)")
                .fontWeight(.medium)
                .font(.title)
        }
    }
    
    @ViewBuilder
    var topHoleView: some View {
        HStack {
            if liveRoundViewModel.currentHole > 1 {
                Button(action: {
                    Task {
                        await liveRoundViewModel.navigateHoles(shouldMoveToNext: false)
                    }
                }, label: {
                    Image(systemName: "arrow.left.square.fill")
                        .resizable()
                        .frame(maxWidth: 50, maxHeight: 50)
                        .foregroundStyle(Color.green)
                        .padding(.leading)
                })
            } else {
                Spacer()
            }
            Spacer()
            if liveRoundViewModel.selectedUser.localId == liveRoundViewModel.user.localId {
                if let data = liveRoundViewModel.user.profilePicData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .background {
                            Circle().fill(Color("AppGray"))
                        }
                        .padding(.trailing, 10)
                        .foregroundStyle(.whiteOrDark)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .background {
                            Circle().fill(Color("AppGray"))
                        }
                        .foregroundStyle(.whiteOrDark)
                }
            } else {
                let selectedUserId = liveRoundViewModel.selectedUser.localId
                if !liveRoundViewModel.otherUsers.isEmpty {
                    let selectedUser = liveRoundViewModel.otherUsers.first(where: { $0.localId == selectedUserId })
                    if let data = selectedUser?.profilePicData,
                       let uiImage = UIImage(data: data) {
                        
                        // Display the user's profile picture
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .background {
                                Circle().fill(Color("AppGray"))
                            }
                            .padding(.trailing, 10)
                            .foregroundStyle(.whiteOrDark)
                        
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            .background {
                                Circle().fill(Color("AppGray"))
                            }
                            .foregroundStyle(.whiteOrDark)
                    }
                }
                
            }
            Spacer()
            if liveRoundViewModel.roundFinished {
                Button(action: {
                    Task {
                        liveRoundViewModel.submitRound()
                    }
                }, label: {
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .foregroundStyle(Color.green)
                        .frame(maxWidth: 50, maxHeight: 50)
                        .padding(.trailing)
                })
            } else {
                Button(action: {
                    Task {
                        await liveRoundViewModel.navigateHoles(shouldMoveToNext: true)
                    }
                }, label: {
                    Image(systemName: "arrow.right.square.fill")
                        .resizable()
                        .foregroundStyle(Color.green)
                        .frame(maxWidth: 50, maxHeight: 50)
                        .padding(.trailing)
                })
            }
        }
        Picker(selection: $liveRoundViewModel.selectedUser, label: Text("Select User")) {
            // Include the main user
            Text("\(liveRoundViewModel.user.firstName) \(liveRoundViewModel.user.lastName)")
                .tag(AnyGolfUser(liveRoundViewModel.user))
                .foregroundStyle(.black)
            
            if !liveRoundViewModel.otherUsers.isEmpty {
                ForEach(liveRoundViewModel.otherUsers, id: \.localId) { otherUser in
                    Text("\(otherUser.firstName) \(otherUser.lastName)")
                        .tag(AnyGolfUser(otherUser))
                        .foregroundStyle(.black)
                }
            }
            
        }
        .onChange(of: liveRoundViewModel.selectedUser) { _, newUser in
            liveRoundViewModel.updateSelectedUser(user: newUser)
            print(liveRoundViewModel.selectedUsers)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green.opacity(0.3))
        )
    }
    
    @ViewBuilder
    var scoreAndPuttView: some View {
        HStack {
            scoreView
            puttView
        }
        .frame(minHeight: 150)
    }
    
    @ViewBuilder
    var puttView: some View {
        VStack {
            Text("Putts")
                .font(.title3)
                .kerning(1.2)
                .fontWeight(.semibold)
            puttPicker
                .frame(maxHeight: 125)
                .pickerStyle(.wheel)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.green.opacity(0.3))
                        .padding(.horizontal, 10)
                )
        }
    }
    
    @ViewBuilder
    var puttPicker: some View {
        Picker(selection: $liveRoundViewModel.selectedPutts, label: Text("Picker")) {
            Text("1").tag(1)
            Text("2").tag(2)
            Text("3").tag(3)
            Text("4").tag(4)
            Text("5").tag(5)
        }
    }
    
    @ViewBuilder
    var scoreView: some View {
        VStack {
            Text("Score")
                .font(.title3)
                .kerning(1.2)
                .fontWeight(.semibold)
            scorePicker
                .frame(maxHeight: 125)
                .pickerStyle(.wheel)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.green.opacity(0.3))
                        .padding(.horizontal, 10)
                )
        }
    }
    
    @ViewBuilder
    var scorePicker: some View {
        Picker(selection: $liveRoundViewModel.selectedScore, label: Text("Picker")) {
            Text("-3").tag(-3)
            Text("-2").tag(-2)
            Text("0").tag(0)
            Text("+1").tag(1)
            Text("+2").tag(2)
            Text("+3").tag(3)
            Text("+4").tag(4)
            Text("+5").tag(5)
        }
    }
    
    @ViewBuilder
    var currentScoreView: some View {
        HStack {
            Text("Current Score: ")
            if liveRoundViewModel.selectedUser.localId == liveRoundViewModel.user.localId {
                let currentScore = liveRoundViewModel.liveRoundModel.userRoundData.roundData.currentScore
                if currentScore == 0 {
                    Text("Even par.")
                } else if currentScore > 0 {
                    Text("+ \(currentScore)")
                } else {
                    Text("\(currentScore)")
                }
            } else {
                // Handle the selected other user
                if let otherUserRound = liveRoundViewModel.liveRoundModel.otherUsersRoundData?.first(where: {
                    $0.otherUser.localId == liveRoundViewModel.selectedUser.localId }) {
                    let currentScore = otherUserRound.roundData.currentScore
                    if currentScore == 0 {
                        Text("Even par.")
                    } else if currentScore > 0 {
                        Text("+ \(currentScore)")
                    } else {
                        Text("\(currentScore)")
                    }
                } else {
                    Text("Score not available")
                }
            }
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.green.opacity(0.3))
                .padding(.horizontal, 10)
        )
    }
}
