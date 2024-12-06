//
//  User.swift
//  Lost
//
//  Created by Ryan Ye on 11/24/24.
//
import SwiftUI

struct AppUserReturn:Codable{
    var data: AppUser
    var success: Bool
}

struct AppUser:Codable{
    var id: Int
    var profileImage: String
    var username: String
    var bio: String
    var email: String
    var phone: String
    var licenseApprove: Bool
    var requests: [Post]
    var items: [Post]
    var timestamp: Date
    var addedItems: [Post]
}
