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
                
                Text("All Recipes")
                    .bold()
                    .padding(.top, 40)
                    .font(.largeTitle)
                
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        
                        ForEach(model.recipes) { recipe in
                            
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
                                        .foregroundColor(.black)
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
    }
}
