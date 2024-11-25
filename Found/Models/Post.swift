//
//  Post.swift
//  Lost
//
//  Created by Ryan Ye on 11/23/24.
//

struct Post : Codable {
    let id: Int
    let colors: [String]
    let category: String
    let subcategory: String
    let description: String
    let imageUrl: String
    let locationFound: String
    let locationAt: String
    let phoneNumber: String
    let email: String
    let dateFound: String
}
