//
//  Recipe.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import Foundation

class RecipeJSON : Identifiable, Decodable {
    
    var id : UUID?
    var name : String
    var category: String
    var featured : Bool
    var image : String
    var description : String
    var prepTime : String
    var cookTime : String
    var totalTime : String
    var servings : Int
    var highlights : [String]
    var ingredients : [IngredientJSON]
    var directions : [String]
    
}
