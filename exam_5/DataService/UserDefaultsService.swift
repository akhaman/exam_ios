//
//  UserDefaultsService.swift
//  exam_5
//
//  Created by Руслан Ахмадеев on 23.01.2021.
//

import Foundation

class UserDefaultsService: DataService {
    private let key = "Recipe"
    private let userDefaults = UserDefaults.standard
    
    private lazy var recipes: [Recipe] = {
        let recipes = userDefaults.object(forKey: key) as? [Recipe]
        return recipes ?? []
    }()
   
    func createRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
    }
    
    func updateRecipe(_ recipe: Recipe) {
        guard let index = recipes.firstIndex(where: { $0.id == recipe.id }) else { return }
        recipes[index] = recipe
    }
    
    func getRecipes() -> [Recipe] {
        return recipes
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        guard let index = recipes.firstIndex(where: { $0.id == recipe.id }) else { return }
        recipes.remove(at: index)
    }
}

// MARK: - Для сохранения результата
extension UserDefaultsService {
    func saveResult() {
        userDefaults.setValue(recipes, forKey: key)
    }
}
