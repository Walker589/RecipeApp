//
//  DataService.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import Foundation

class DataService {
    
    static func getLocalData() -> [RecipeJSON] {
        let pathString = Bundle.main.path(forResource: "recipes", ofType: "json")
        
        guard pathString != nil else {
            return [RecipeJSON]()
        }
        
        let url = URL(fileURLWithPath: pathString!)
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            
            do {
                let recipeData = try decoder.decode([RecipeJSON].self, from: data)
                
                for recipe in recipeData {
                    recipe.id = UUID()
                    
                    for ingredient in recipe.ingredients {
                        ingredient.id = UUID()
                    }
                    
                }
                
                return recipeData
                
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
        
        return [RecipeJSON]()
    }
}
