//
//  LiveRoundFirebaseModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 12/12/24.
//

import Foundation

struct LiveRoundFirebaseModel: Codable {
    let id: String
    let currentHole: Int
    let courseName: String
    let likes: [String]?
    let users: LiveRoundUsers
}

struct LiveRoundUsers: Codable {
    let mainUser: LiveRoundUser
    let otherUser: LiveRoundUser
}

struct LiveRoundUser: Codable {
    let id: String
    let score: Int
}

struct LiveRoundFirebaseUsers: Codable {
    let mainUser: OtherUser
    let otherUser: OtherUser?
}
