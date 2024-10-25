//
//  LiveRoundAttributes.swift
//  LiveRoundExtension
//
//  Created by Zack Boutchyard on 10/24/24.
//

import ActivityKit
import Foundation

struct LiveRoundAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var currentScore: Int
        var currentHole: Int
        var courseName: String
    }
}
