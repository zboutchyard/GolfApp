//
//  UserModel.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/4/23.
//

import Foundation

class User: ObservableObject{
    @Published var firstName: String
    @Published var lastName: String
    @Published var email: String
    @Published var chats: [String]
    @Published var friendsList: [String]
    
    init(firstName: String, lastName: String, email: String, chats: [String], friendsList: [String]) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.chats = chats
        self.friendsList = friendsList
    }
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
