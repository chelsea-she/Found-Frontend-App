//
//  Post.swift
//  Lost
//
//  Created by Ryan Ye on 11/23/24.
//

struct Post : Codable {
    let id: String
    var itemName: String
    var timestamp: String
    var locationFound: String
    var dropLocation: String
    var color: [String]
    var category: String
    var image: String
    var fulfilled: Bool
    let userID: Int
}
