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
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
