//
//  AddRecipeTabView.swift
//  Recipe App
//
//  Created by Ali Earp on 07/09/2022.
//

import SwiftUI

struct AddRecipeTabView: View {
    @EnvironmentObject var model: RecipeModel
    
    @State var tabSelection = 1
    
    var body: some View {
        TabView(selection: $model.pageNumber) {
            AddIngredientsView()
                .tag(1)
                .padding(.horizontal, 10)
            
            AddDirectionsView()
                .tag(2)
                .padding(.horizontal, 10)
            
            AddHighlightsView()
                .tag(3)
                .padding(.horizontal, 10)
            
            AddRecipeView()
                .tag(4)
                .padding(.horizontal, 10)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
    }
}

struct AddRecipeTabView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeTabView()
    }
}
