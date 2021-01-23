//
//  Recipe.swift
//  exam_5
//
//  Created by Руслан Ахмадеев on 23.01.2021.
//

import Foundation

struct Recipe {
    let id: UUID = .init()
    var name: String
    var ingredients: [String]
    var instruction: String
}
