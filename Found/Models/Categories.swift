//
//  Categories.swift
//  Lost
//
//  Created by Ryan Ye on 11/24/24.
//
import SwiftUI

struct Categories{
    var categories: [String] = ["Clothing", "Personal items","Jewelry", "Electronics", "Valuables", "ID/Key/Wallet"]
    var colors: [String] = ["Black", "Gray", "White", "Beige", "Brown", "Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Rainbow"]
    var uiColors: [Color] = [.black, .gray, .white, Color(red: 0.96, green: 0.94, blue: 0.84), .brown, .red, .orange, .yellow, .green, .blue, .purple, .white]
    var colorOptions: [ColorOption] {
        zip(colors, uiColors).map { ColorOption(name: $0.0, color: $0.1) }
    }
}

struct ColorOption: Hashable {
    let name: String
    let color: Color
}
