//
//  Message.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 11/6/23.
//

import Foundation

struct Message: Identifiable, Codable, Hashable {
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}

struct Participants: Codable, Hashable {
    var participants: [String]
}
