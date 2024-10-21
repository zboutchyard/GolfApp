//
//  TeeOptions.swift
//  GolfApp
//
//  Created by Zack Boutchyard on 7/27/24.
//

import Foundation
import SwiftUI

struct TeeOption {
    let name: String
    let color: Color
}

let teeOptions = [
    TeeOption(name: "Black", color: .black),
    TeeOption(name: "Blue", color: .blue),
    TeeOption(name: "White", color: .white),
    TeeOption(name: "Yellow", color: .yellow),
    TeeOption(name: "Red", color: .red)
]

struct GolfCourse {
    let name: String
    let address: String
}

enum GolfCourseLoadingState {
    case loading
    case loaded
    case error
}
