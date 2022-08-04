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
    
}
