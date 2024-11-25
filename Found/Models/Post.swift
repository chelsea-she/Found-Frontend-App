//
//  Post.swift
//  Lost
//
//  Created by Ryan Ye on 11/23/24.
//

struct Post : Codable {
    let id: String
    let userId: String
    let color: [String]
    let category: String
    let description: String
    let image: String
    let currentLocation: String
    let location: String
    let finderNumber: String
    let finderEmail: String
    let timestamp: String
}
