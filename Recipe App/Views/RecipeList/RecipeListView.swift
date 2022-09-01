//
//  ContentView.swift
//  Recipe App
//
//  Created by Ali Earp on 03/08/2022.
//

import SwiftUI

struct RecipeListView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var recipes: FetchedResults<Recipe>
    
    @State private var filterBy = ""
    
    private var filteredRecipes: [Recipe] {
        if filterBy.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return Array(recipes)
        } else {
            return recipes.filter { recipe in
                return recipe.name.lowercased().contains(filterBy.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("All Recipes")
                    .bold()
                    .padding(.top, 40)
                    .font(Font.custom("Avenir Heavy", size: 24))
                    .foregroundColor(.primary)
                
                SearchBar(filterBy: $filterBy)
                    .padding([.trailing, .bottom])
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(filteredRecipes) { recipe in
                            
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                HStack(spacing: 20) {
                                    let image = UIImage(data: recipe.image ?? Data())
                                    Image(uiImage: image ?? UIImage())
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
            .navigationBarHidden(true)
            .padding(.leading)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}
