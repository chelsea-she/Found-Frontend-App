//
//  User.swift
//  Lost
//
//  Created by Ryan Ye on 11/24/24.
//
import SwiftUI

struct AppUser{
    let id: String
    var profileImage: String
    var username: String
    var bio: String
    var email: String
    var phone: String
    var licenseApprove: Bool
    var requests: [Post]
    var items: [Post]
    var timestamp: Date
}
