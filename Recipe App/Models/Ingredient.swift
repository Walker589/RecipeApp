//
//  Ingredient.swift
//  Recipe App
//
//  Created by Ali Earp on 06/08/2022.
//

import Foundation

class Ingredient : Identifiable, Decodable {
    
    var id : String = ""
    var name : String = ""
    var num : Int? = 0
    var denom : Int? = 0
    var unit : String? = ""
    
}
