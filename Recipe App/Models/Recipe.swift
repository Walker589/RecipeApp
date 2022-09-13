//
//  Recipe.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import Foundation
import UIKit

class Recipe : Identifiable, Decodable {
    
    var id : String = ""
    var name : String = ""
    var cuisine: String = ""
    var featured : Bool = false
    var image : Data = Data()
    var prepTime : String = ""
    var servings : Int = 0
    var highlights : [String] = [String]()
    var ingredients : [Ingredient] = [Ingredient]()
    var directions : [String] = [String]()
    
}
