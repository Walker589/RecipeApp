//
//  AddIngredientLine.swift
//  Recipe App
//
//  Created by Ali Earp on 02/09/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AddIngredientLine: View {
    @EnvironmentObject var model: RecipeModel
    
    @Binding var ingredientName: String
    @Binding var num: String
    @Binding var denom: String
    @Binding var unit: String
    
    var body: some View {
        HStack {
            TextField("Name", text: $ingredientName)
            Spacer()
            
            Group {
                TextField("", text: $num)
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing, -8)
                Text("/")
                TextField("", text: $denom)
                    .padding(.leading, -9)
            }.frame(maxWidth: 20)
            
            TextField("Unit", text: $unit)
                .autocapitalization(.none)
                .multilineTextAlignment(.trailing)
                .padding(.trailing)
            
            Button("Add") {
                let cleanedName = ingredientName.trimmingCharacters(in: .whitespacesAndNewlines)
                let cleanedNum = num.trimmingCharacters(in: .whitespacesAndNewlines)
                let cleanedDenom = denom.trimmingCharacters(in: .whitespacesAndNewlines)
                let cleanedUnit = unit.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if cleanedName == "" || cleanedNum == "" || cleanedDenom == "" {
                    return
                }

                let ingredient = Ingredient()
                ingredient.id = UUID().uuidString
                ingredient.name = cleanedName
                ingredient.num = Int(cleanedNum) ?? 1
                ingredient.denom = Int(cleanedDenom) ?? 1
                ingredient.unit = cleanedUnit
                
                model.ingredients.append(ingredient)
                
                ingredientName = ""
                unit = ""
                num = ""
                denom = ""
                
                model.addIngredientLine = false
            }.foregroundColor(.green)
        }.font(.headline)
    }
}
