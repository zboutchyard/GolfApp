//
//  LiveRoundViewModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 8/11/24.
//

import Foundation

class LiveRoundViewModel: ObservableObject {
    @Published var currentHole: Int = 1
    @Published var missingSelectedUser: Bool = false
    @Published var roundFinished: Bool = false
    @Published var selectedScore: Int = 0
    @Published var selectedPutts: Int = 1
    @Published var liveRoundModel: LiveRound
    @Published var user: User
    @Published var otherUsers: [OtherUser]
    @Published var missingInput: Bool = false
    @Published var selectedUsers: Set<AnyGolfUser> = []
    @Published var selectedUser: AnyGolfUser
    @Published var selectedCourseName: String
    @Published var totalHoles: Int
    
    init(totalHoles: Int = 9, user: User, otherUsers: [OtherUser], selectedCourseName: String) {
        self.user = user
        self.selectedUser = AnyGolfUser(user)
        self.otherUsers = otherUsers
        var otherUsersRoundData: [OtherUserRoundModel] = []
        self.selectedCourseName = selectedCourseName
        self.totalHoles = totalHoles
        
        // Check if there are other users and create their round data
        if !otherUsers.isEmpty {
            for otherUser in otherUsers {
                let roundData = RoundData(
                    holes: (1...totalHoles).map { Hole(holeNumber: $0) },
                    currentScore: 0,
                    currentPutts: 0
                )
                let otherUserRoundModel = OtherUserRoundModel(otherUser: otherUser, roundData: roundData)
                otherUsersRoundData.append(otherUserRoundModel)
            }
        }
        
        self.liveRoundModel = LiveRound(
            userRoundData: UserRoundModel(
                user: user,
                roundData: RoundData(
                    holes: (1...totalHoles).map { Hole(holeNumber: $0) },
                    currentScore: 0,
                    currentPutts: 0
                )
            ),
            otherUsersRoundData: otherUsersRoundData
        )
    }
    
    func updateSelectedUser(user: AnyGolfUser) {
        selectedScore = 0
        selectedPutts = 1
        if !selectedUsers.contains(selectedUser) {
            selectedUsers.insert(selectedUser)
        }
    }
    
    @MainActor
    func areAllUsersSelected() async -> Bool {
        if !otherUsers.isEmpty {
                let allOthersMatch = otherUsers.allSatisfy { otherUser in
                    selectedUsers.contains { selectedUser in
                        selectedUser.localId == otherUser.localId // or compare other properties
                    }
                }
                selectedUsers.removeAll()
                selectedUsers.insert(AnyGolfUser(user))
                selectedUser = AnyGolfUser(user)
                return allOthersMatch
            } else {
                return true
            }
    }
    
    private var selectedUserRoundData: RoundData {
        if selectedUser.localId == user.localId {
            return liveRoundModel.userRoundData.roundData
        } else {
            return liveRoundModel.otherUsersRoundData?.first(where: {
                $0.otherUser.localId == selectedUser.localId
            })?.roundData ?? RoundData(holes: [], currentScore: 0, currentPutts: 0)
        }
    }
    
    @MainActor
    func navigateHoles(shouldMoveToNext: Bool) async {
        print("navigateHoles called with shouldMoveToNext: \(shouldMoveToNext)")

        if shouldMoveToNext {
            let hasSelectedAllUsers: Bool = await areAllUsersSelected()
            print("hasSelectedAllUsers: \(hasSelectedAllUsers)") // Check the result

            guard hasSelectedAllUsers else {
                missingSelectedUser = true
                print("Missing selected user.")
                return
            }

            // Proceed with updating scores and navigating holes
            if currentHole < selectedUserRoundData.holes.count {
                updateScore(for: currentHole, score: selectedScore)
                updatePutts(for: currentHole, putts: selectedPutts)

                currentHole += 1
                selectedPutts = 0
                selectedScore = 0
            } else {
                updateScore(for: currentHole, score: selectedScore)
                updatePutts(for: currentHole, putts: selectedPutts)
                roundFinished = true
            }
        } else {
            if currentHole > 0 {
                currentHole -= 1
                selectedPutts = 0
                selectedScore = 0
            }
        }
    }

    @MainActor
    func updateScore(for hole: Int, score: Int) {
        guard hole >= 0 && hole < selectedUserRoundData.holes.count else { return }
        
        // Update the score for the selected user
        if selectedUser.localId == user.localId {
            liveRoundModel.userRoundData.roundData.holes[hole].score = score
        } else {
            if let index = liveRoundModel.otherUsersRoundData?.firstIndex(where: { $0.otherUser.localId == selectedUser.localId }) {
                liveRoundModel.otherUsersRoundData?[index].roundData.holes[hole].score = score
            }
        }
        recalculateTotalScore()
    }
    
    @MainActor
    func updatePutts(for hole: Int, putts: Int) {
        guard hole >= 0 && hole < selectedUserRoundData.holes.count else { return }
        
        // Update the putts for the selected user
        if selectedUser.localId == user.localId {
            liveRoundModel.userRoundData.roundData.holes[hole].putts = putts
        } else {
            if let index = liveRoundModel.otherUsersRoundData?.firstIndex(where: { $0.otherUser.localId == selectedUser.localId }) {
                liveRoundModel.otherUsersRoundData?[index].roundData.holes[hole].putts = putts
            }
        }
        recalculateTotalPutts()
    }
    
    @MainActor
    private func recalculateTotalScore() {
        let total = selectedUserRoundData.holes.reduce(0) { $0 + $1.score }
        if selectedUser.localId == user.localId {
            liveRoundModel.userRoundData.roundData.currentScore = total
        } else {
            if let index = liveRoundModel.otherUsersRoundData?.firstIndex(where: { $0.otherUser.localId == selectedUser.localId }) {
                liveRoundModel.otherUsersRoundData?[index].roundData.currentScore = total
            }
        }
    }
    
    @MainActor
    private func recalculateTotalPutts() {
        let total = selectedUserRoundData.holes.reduce(0) { $0 + $1.putts }
        if selectedUser.localId == user.localId {
            liveRoundModel.userRoundData.roundData.currentPutts = total
        } else {
            if let index = liveRoundModel.otherUsersRoundData?.firstIndex(where: { $0.otherUser.localId == selectedUser.localId }) {
                liveRoundModel.otherUsersRoundData?[index].roundData.currentPutts = total
            }
        }
    }
    
    func submitRound() {
        ///
        /// TODO: implement function
        ///  this function will present a summary page showing how they did during the round.
        ///  the next step after the summary page will create a post depending on if the user wants to share showing where the user played, and what score they had for the round.
        ///
    }
}
