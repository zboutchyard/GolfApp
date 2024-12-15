//
//  LiveRound.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 8/11/24.
//

import Foundation

struct LiveRoundNotificationModel {
    var userRoundData: UserRoundModel
    var otherUsersRoundData: [OtherUserRoundModel]?
    
}

struct UserRoundModel {
    var user: User
    var roundData: RoundData
}

struct OtherUserRoundModel {
    var otherUser: OtherUser
    var roundData: RoundData
}

struct RoundData {
    var holes: [Hole]
    var currentScore: Int
    var currentPutts: Int
}

struct Hole {
    var holeNumber: Int
    var score: Int
    var putts: Int
    
    init(holeNumber: Int, score: Int = 0, putts: Int = 0) {
        self.holeNumber = holeNumber
        self.score = score
        self.putts = putts
    }
}
