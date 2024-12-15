//
//  UserModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import FirebaseFirestore
import Foundation
import SwiftUI

struct User: Codable, Hashable {
    var localId = UUID()
    var firstName: String
    var lastName: String
    var email: String
    var profilePicData: Data?
    var chats: [String]?
    var friendsList: [String]?
    var bio: String?
    var interests: String?
    var handicap: Int?
    var homeCourse: String?
    var posts: [String]?
    var sentRequests: [Request]?
    var receivedRequests: [Request]?
    var notifications: [Notification]?
    var fcmToken: String?
    var liveRound: String?
    
    init(firstName: String, lastName: String, email: String, profilePicData: Data? = nil, chats: [String]? = nil, friendsList: [String]? = nil, bio: String? = nil, interests: String? = nil, handicap: Int? = nil, homeCourse: String? = nil, posts: [String]? = nil, sentRequests: [Request]? = nil, receivedRequests: [Request]? = nil, notifications: [Notification]? = nil, fcmToken: String? = nil, liveRound: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.profilePicData = profilePicData
        self.chats = chats
        self.friendsList = friendsList
        self.bio = bio
        self.interests = interests
        self.handicap = handicap
        self.homeCourse = homeCourse
        self.posts = posts
        self.sentRequests = sentRequests
        self.receivedRequests = receivedRequests
        self.notifications = notifications
        self.fcmToken = fcmToken
        self.liveRound = liveRound
    }
}

struct Request: Codable, Hashable {
    var user: String
}

struct Notification: Codable, Hashable {
    var id: String
    var hasBeenRead: Bool
    var text: String
    var timeStamp: Date
    var userCommenting: String
    var postId: String
}

struct OtherUser: Codable, Hashable {
    var localId = UUID()
    var id: String
    var firstName: String
    var profilePicData: Data?
    var lastName: String
    var bio: String?
    var interests: String?
    var handicap: Int?
    var homeCourse: String?
    var posts: [String]?
}

struct AnyGolfUser: GolfUser, Hashable {
    private let base: any GolfUser
    
    init<U: GolfUser>(_ user: U) {
        self.base = user
    }
    var localId: UUID { base.localId }
    var firstName: String { base.firstName }
    var lastName: String { base.lastName }
    
    static func == (lhs: AnyGolfUser, rhs: AnyGolfUser) -> Bool {
        return lhs.localId == rhs.localId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(localId)
    }
}

protocol GolfUser: Hashable, Equatable {
    var localId: UUID { get }
    var firstName: String { get }
    var lastName: String { get }
}

extension User: GolfUser {}
extension OtherUser: GolfUser {}
