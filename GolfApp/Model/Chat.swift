//
//  Message.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import Foundation

struct Chat: Codable, Hashable {
    var participants: [String]?
    var messages: [Message]?
}

struct Message: Codable, Hashable {
    var sender: String?
    var text: String?
    var timestamp: Date?
}
