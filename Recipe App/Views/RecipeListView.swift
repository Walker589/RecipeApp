//
//  ContentView.swift
//  Recipe App
//
//  Created by Ali Earp on 03/08/2022.
//

import SwiftUI

struct RecipeListView: View {    
    @EnvironmentObject var model : RecipeModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                Text(model.selectedCategory ?? Constants.defaultListFilter)
                    .bold()
                    .padding(.top, 40)
                    .font(Font.custom("Avenir Heavy", size: 24))
                    .foregroundColor(.primary)
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(model.recipes) { recipe in
                            
                            if model.selectedCategory == nil || model.selectedCategory == Constants.defaultListFilter || model.selectedCategory != nil && recipe.category == model.selectedCategory {
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
                                        
                                        VStack(alignment: .leading) {
                                            Text(recipe.name)
                                                .foregroundColor(.primary)
                                                .font(Font.custom("Avenir Heavy", size: 16))
                                            RecipeHighlightsView(highlights: recipe.highlights)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .padding(.leading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
            .environmentObject(RecipeModel())
            .preferredColorScheme(.dark)
    }
}
