//
//  RecipeTabView.swift
//  Recipe List App
//
//  Created by Ali Earp on 04/08/2022.
//

import SwiftUI

struct RecipeTabView: View {
    @State var selectedTab = Constants.featuredTab
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipeFeaturedView()
                .padding(.bottom)
                .tabItem {
                    VStack {
                        Image(systemName: "star.fill")
                        Text("Featured")
                    }
                }.tag(Constants.featuredTab)
            
            RecipeCategoryView(selectedTab: $selectedTab)
                .padding(.bottom)
                .tabItem {
                    VStack {
                        Image(systemName: "square.grid.2x2")
                        Text("Categories")
                    }
                }.tag(Constants.categoriesTab)
            
            RecipeListView()
                .padding(.bottom)
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                }.tag(Constants.listTab)
            
        }
        .environmentObject(RecipeModel())
    }
}

struct RecipeTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeTabView()
            .preferredColorScheme(.dark)
    }
}
