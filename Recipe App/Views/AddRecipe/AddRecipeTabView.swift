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
            
            AddRecipeView()
                .tag(3)
                .padding(.horizontal, 10)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct AddRecipeTabView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeTabView()
    }
}
