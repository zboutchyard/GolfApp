//
//  Post.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/26/23.
//

import Foundation



struct Post: Codable, Hashable {
    var likes: [String]
    var text: String
    var timeStamp: Date
    var user: String
}
