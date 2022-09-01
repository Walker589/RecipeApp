//
//  AddIngredientData.swift
//  Recipe App
//
//  Created by Ali Earp on 31/08/2022.
//

import SwiftUI

struct AddIngredientData: View {
    @Binding var ingredients: [IngredientJSON]
    
    @State var name = ""
    @State var unit = ""
    @State var num = ""
    @State var denom = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ingredients: ")
                .bold()
                .padding(.top, 5)
            
            HStack {
                TextField("Sugar", text: $name)
                TextField("1", text: $num)
                    .frame(width: 20)
                Text("/")
                TextField("2", text: $denom)
                    .frame(width: 20)
                TextField("cups", text: $unit)
                
                Button("Add") {
                    let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cleanedNum = num.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cleanedDenom = denom.trimmingCharacters(in: .whitespacesAndNewlines)
                    let cleanedUnit = unit.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if cleanedName == "" || cleanedNum == "" || cleanedDenom == "" || cleanedUnit == "" {
                        return
                    }
                    
                    let ingredient = IngredientJSON()
                    ingredient.id = UUID()
                    ingredient.name = cleanedName
                    ingredient.unit = cleanedUnit
                    ingredient.num = Int(cleanedNum) ?? 1
                    ingredient.denom = Int(cleanedDenom) ?? 1
                    
                    ingredients.append(ingredient)
                    
                    name = ""
                    unit = ""
                    num = ""
                    denom = ""
                }
            }
            
            ForEach(ingredients) { ingredient in
                Text("\(ingredient.name), \(ingredient.num ?? 1)/\(ingredient.denom ?? 1) \(ingredient.unit ?? "")")
            }
        }
    }
}
