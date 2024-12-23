//
//  Post.swift
//  Lost
//
//  Created by Ryan Ye on 11/23/24.
//
import Foundation
struct FoundResponseData: Codable{
    let success: Bool
    let data: Post
}

struct LostResponseData: Codable{
    let success: Bool
    let data: [Post]
}

struct Post : Codable {
    let id: Int
    var itemName: String
    var description: String
    var timestamp: Date
    var locationFound: String
    var dropLocation: String
    var color: String
    var category: String
    var image: String
    var fulfilled: Bool
    let userId: Int
}

extension Post{
    public static var dummyData = [Post(
        id: 1,
        itemName: "1",
        description: "1",
        timestamp: Date(),
        locationFound: "1",
        dropLocation: "1",
        color: "1",
        category: "1",
        image: "url",
        fulfilled: false,
        userId: 1
    )
    ]
    public static var dummyID = -600673
    public static var dummyString = "today"
    
}
