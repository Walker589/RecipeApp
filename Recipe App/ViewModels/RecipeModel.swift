//
//  RecipeModel.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import Foundation

class RecipeModel : ObservableObject {
    
    @Published var recipes = [Recipe]()
    
    init() {
        
        self.recipes = DataService.getLocalData()
        
    }
    
    static func getPortion(ingredient: Ingredient, recipeServings: Int, targetServings: Int) -> String {
        
        var portion = ""
        var numerator = ingredient.num ?? 1
        var denominator = ingredient.denom ?? 1
        var wholePortions = 0
        
        if ingredient.num != nil {
            
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
            
        }

        if var unit = ingredient.unit {
            
            if wholePortions > 1 {
                
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
