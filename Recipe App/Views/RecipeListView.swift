//
//  ContentView.swift
//  Recipe App
//
//  Created by Ali Earp on 03/08/2022.
//

import SwiftUI

struct RecipeListView: View {
    
    @ObservedObject var model = RecipeModel()
    
    var body: some View {
        
        NavigationView {
            
            List(model.recipes) { recipe in
                
                NavigationLink {
                    RecipeDetailView(recipe: recipe)
                } label: {
                    HStack(spacing: 20) {
                        Image(recipe.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipped()
                            .cornerRadius(5)
                        
                        Text(recipe.name)
                    }
                }
                
            }
            .listStyle(.inset)
            .navigationTitle("All Recipes")
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
