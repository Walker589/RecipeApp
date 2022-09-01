//
//  RecipeTabView.swift
//  Recipe List App
//
//  Created by Ali Earp on 04/08/2022.
//

import SwiftUI

struct RecipeTabView: View {
    @State var tabSelection = 0
    
    var body: some View {
        TabView(selection: $tabSelection) {
            RecipeFeaturedView()
                .padding(.bottom)
                .tabItem {
                    VStack {
                        Image(systemName: "star.fill")
                        Text("Featured")
                    }
                }.tag(Constants.featuredTab)
            
            RecipeListView()
                .padding(.bottom)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                }.tag(Constants.listTab)
            
            AddRecipeView(tabSelection: $tabSelection)
                .padding(.bottom)
                .tabItem {
                    VStack {
                        Image(systemName: "plus")
                        Text("Add Recipe")
                    }
                }.tag(Constants.addRecipeTab)
        }.environmentObject(RecipeModel())
    }
}
