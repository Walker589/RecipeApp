//
//  RecipeTabView.swift
//  Recipe List App
//
//  Created by Ali Earp on 04/08/2022.
//

import SwiftUI

struct RecipeTabView: View {
    @EnvironmentObject var model: RecipeModel
    
    @State var tabSelection = 0
    @State var isSheetPresented = true
    
    var body: some View {
        if model.fetchedRemoteData {
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
                
                AddRecipeTabView()
                    .padding(.bottom)
                    .tabItem {
                        VStack {
                            Image(systemName: "plus")
                            Text("Add Recipe")
                        }
                    }.tag(Constants.addRecipeTab)
                
                ProfileView()
                    .padding(.bottom)
                    .tabItem {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                    }.tag(Constants.profileTab)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}
