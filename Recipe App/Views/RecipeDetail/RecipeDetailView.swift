//
//  RecipeDetailView.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    
    @State var selectedServingSize = 2
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                let image = UIImage(data: recipe.image)
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .scaledToFill()
                
                Text(recipe.name)
                    .bold()
                    .padding(.top, 20)
                    .padding(.leading)
                    .padding(.bottom, 10)
                    .font(Font.custom("Avenir Heavy", size: 24))
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading) {
                    
                    Text("Select your serving size:")
                        .font(Font.custom("Avenir", size: 15))
                    Picker("", selection: $selectedServingSize) {
                        Text("2").tag(2)
                        Text("4").tag(4)
                        Text("6").tag(6)
                        Text("8").tag(8)
                    }
                    .font(Font.custom("Avenir", size: 15))
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 160)
                    
                }
                .padding(.leading)
                .foregroundColor(.primary)
                
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(Font.custom("Avenir Heavy", size: 16))
                        .padding([.bottom, .top], 5)
                    
                    ForEach(recipe.ingredients) { ingredient in
                        Text("• " + RecipeModel.getPortion(ingredient: ingredient,
                                                           recipeServings: recipe.servings,
                                                           targetServings: selectedServingSize) + " " +  ingredient.name.lowercased())
                        .font(Font.custom("Avenir", size: 15))
                    }
                }
                .padding(.horizontal, 10)
                .foregroundColor(.primary)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Directions")
                        .font(Font.custom("Avenir Heavy", size: 16))
                        .padding([.bottom, .top], 5)
                    
                    ForEach(0..<recipe.directions.count, id: \.self) { index in
                        Text("\(String(index + 1)). \(recipe.directions[index])")
                            .padding(.bottom, 5)
                            .font(Font.custom("Avenir", size: 15))
                    }
                }
                .padding(.horizontal, 10)
                .foregroundColor(.primary)
                
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}
