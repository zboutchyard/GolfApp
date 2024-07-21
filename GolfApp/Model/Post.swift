//
//  Post.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/26/23.
//

import Foundation

struct Post: Codable, Hashable {
    var id: String?
    var likes: [String]?
    var text: String
    var timeStamp: Date
    var user: String
    var comments: [Comment]?
    var imageRef: String?
    var imageData: Data?
}

struct Comment: Codable, Hashable {
    var text: String
    var timeStamp: Date
    var userCommenting: String
}
