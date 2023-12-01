//
//  UserModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import Foundation

struct User: Codable, Hashable {
    var firstName: String
    var lastName: String
    var email: String
    var chats: [String]?
    var friendsList: [String]?
    var bio: String?
    var interests: String?
    var handicap: Int?
    var homeCourse: String?
    var posts: [String]?
    var notifications: [Notification]?
}

struct Notification: Codable, Hashable {
    var text: String
    var timeStamp: Date
    var userCommenting: String
}

class OtherUser: ObservableObject {
    @Published var id: String
    @Published var firstName: String
    @Published var lastName: String
    
    init(id: String, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
