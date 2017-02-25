//
//  User.swift
//  ListenLive
//
//  Created by Jake on 2/24/17.
//  Copyright © 2017 Nicholas Swift. All rights reserved.
//

import Foundation

class User {
    
    static var current: User?
    
    // MARK: - Instance Vars
    var userID: Int
//    var facebookID: Int
    var email: String
    var profilePictureURL: URL?
    var firstName: String
    var lastName: String
    
    // MARK - Initializers
    init(userID: Int, email: String, profilePictureURL: URL? = nil, firstName: String = "", lastName: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.userID = userID
        self.email = email
        
        // profile picture url doesn't always exist
        self.profilePictureURL = profilePictureURL
    
    }
}
