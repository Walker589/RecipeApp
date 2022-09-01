//
//  RecipeModel.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import Foundation
import UIKit

class RecipeModel : ObservableObject {
    
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var recipes = [Recipe]()
    
    init() {
        checkLoadedData()
    }
    
    func checkLoadedData() {
        let status = UserDefaults.standard.bool(forKey: Constants.isDataPreloaded)
        if status == false {
            preloadLocalData()
        }
    }
    
    func preloadLocalData() {
        let localRecipes = DataService.getLocalData()
        
        for r in localRecipes {
            let recipe = Recipe(context: viewContext)
            recipe.category = r.category
            recipe.id = UUID()
            recipe.image = UIImage(named: r.image)?.jpegData(compressionQuality: 1.0)
            recipe.name = r.name
            recipe.cookTime = r.cookTime
            recipe.directions = r.directions
            recipe.featured = r.featured
            recipe.highlights = r.highlights
            recipe.prepTime = r.prepTime
            recipe.servings = r.servings
            recipe.summary = r.description
            recipe.totalTime = r.totalTime
            
            for i in r.ingredients {
                let ingredient = Ingredient(context: viewContext)
                
                ingredient.id = UUID()
                ingredient.name = i.name
                ingredient.unit = i.unit
                ingredient.num = i.num ?? 1
                ingredient.denom = i.denom ?? 1
                
                recipe.addToIngredients(ingredient)
            }
        }
        
        do {
            try viewContext.save()
            
            UserDefaults.standard.setValue(true, forKey: Constants.isDataPreloaded)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getPortion(ingredient: Ingredient, recipeServings: Int, targetServings: Int) -> String {
        
        var portion = ""
        var numerator = ingredient.num
        var denominator = ingredient.denom
        var wholePortions = 0
        
        // Single Serving Size
        denominator *= recipeServings
        
        // Get Target Portion
        numerator *= targetServings
        
        // Reduce Fraction
        let divisor = Rational.greatestCommonDivisor(numerator, denominator)
        numerator /= divisor
        denominator /= divisor
        
        // Get Whole Portion
        if numerator >= denominator {
            
            // Calculate Whole Portions
            wholePortions = numerator / denominator
            
            // Calculate Remainder
            numerator %= denominator
            
            // Assign to Portion String
            portion += String(wholePortions)
        }
        
        // Express Remainder as Fraction
        if numerator > 0 {
            // Assign Remainder as Fraction to Portion String
            portion += wholePortions > 0 ? " " : ""
            portion += "\(numerator)/\(denominator)"
        }
        
        if var unit = ingredient.unit {
            if wholePortions > 1 || (wholePortions == 1 && numerator > 0) {
                // Calculate Appropriate Suffix
                if unit.suffix(2) == "ch" {
                    unit += "es"
                } else if unit.suffix(1) == "f" {
                    unit = String(unit.dropLast())
                    unit += "ves"
                } else {
                    unit += "s"
                }
            }
            portion += ingredient.num == nil && ingredient.denom == nil ? "" : " "
            
            return portion + unit
        }
        
        return portion
    }
}
