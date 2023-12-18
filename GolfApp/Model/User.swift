//
//  UserModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import Foundation
import SwiftUI

struct User: Codable, Hashable {
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
}

struct Request: Codable, Hashable {
    var user: String
}

struct Notification: Codable, Hashable {
    var text: String
    var timeStamp: Date
    var userCommenting: String
    var postId: String
}

struct OtherUser: Codable, Hashable {
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
