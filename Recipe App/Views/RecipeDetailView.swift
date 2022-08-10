//
//  RecipeDetailView.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import SwiftUI

struct RecipeDetailView: View {
    
    var recipe : Recipe
    
    @State var selectedServingSize = 2
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                
                Image(recipe.image)
                    .resizable()
                    .scaledToFill()
                
                Text(recipe.name)
                    .bold()
                    .padding(.top, 20)
                    .padding(.leading)
                    .padding(.bottom, 10)
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    
                    Text("Select your serving size:")
                    Picker("", selection: $selectedServingSize) {
                        Text("2").tag(2)
                        Text("4").tag(4)
                        Text("6").tag(6)
                        Text("8").tag(8)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 160)
                    
                }.padding(.leading)
                
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.headline)
                        .padding([.bottom, .top], 5)
                    
                    ForEach(recipe.ingredients) { ingredient in
                        Text("• " + RecipeModel.getPortion(ingredient: ingredient, recipeServings: recipe.servings, targetServings: selectedServingSize) + " " +  ingredient.name.lowercased())
                    }
                }.padding(.horizontal, 10)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Directions")
                        .font(.headline)
                        .padding([.bottom, .top], 5)
                    
                    ForEach(0..<recipe.directions.count, id: \.self) { index in
                        Text("\(String(index + 1)). \(recipe.directions[index])")
                            .padding(.bottom, 5)
                    }
                }.padding(.horizontal, 10)
                
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let model = RecipeModel()
        
        RecipeDetailView(recipe: model.recipes[0])
    }
}
