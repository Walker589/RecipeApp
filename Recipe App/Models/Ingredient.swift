//
//  Ingredient.swift
//  Recipe App
//
//  Created by Ali Earp on 06/08/2022.
//

import Foundation

class Ingredient: Identifiable, Decodable {
    
    var id : UUID?
    var name : String
    var num : Int?
    var denom : Int?
    var unit : String?
    
}
