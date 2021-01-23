//
//  DataService.swift
//  exam_5
//
//  Created by Руслан Ахмадеев on 23.01.2021.
//

import Foundation

protocol DataService {
    func createRecipe(_ recipe: Recipe)
    func updateRecipe(_ recipe: Recipe)
    func getRecipes() -> [Recipe]
    func deleteRecipe(_ recipe: Recipe)
}
