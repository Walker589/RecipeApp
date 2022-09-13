//
//  ContentView.swift
//  Recipe App
//
//  Created by Ali Earp on 03/08/2022.
//

import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var model: RecipeModel
    
    @State private var filterBy = ""
    
    private var filteredRecipes: [Recipe] {
        if filterBy.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return model.recipes
        } else {
            return model.recipes.filter { recipe in
                return recipe.name.lowercased().contains(filterBy.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("All Recipes")
                    .bold()
                    .font(Font.custom("Avenir Heavy", size: 24))
                    .foregroundColor(.primary)
                
                SearchBar(filterBy: $filterBy)
                    .padding([.trailing, .bottom])
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(0..<filteredRecipes.count, id: \.self) { index in
                            NavigationLink {
                                RecipeDetailView(recipe: filteredRecipes[index])
                            } label: {
                                HStack(spacing: 20) {
                                    let image = UIImage(data: filteredRecipes[index].image)
                                    Image(uiImage: image ?? UIImage())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .clipped()
                                        .cornerRadius(5)
                                    
                                    VStack(alignment: .leading) {
                                        Text(filteredRecipes[index].name)
                                            .foregroundColor(.primary)
                                            .font(Font.custom("Avenir Heavy", size: 16))
                                        RecipeHighlightsView(highlights: filteredRecipes[index].highlights)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .padding(.leading)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}
