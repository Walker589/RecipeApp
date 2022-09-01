//
//  AddMetaData.swift
//  Recipe App
//
//  Created by Ali Earp on 31/08/2022.
//

import SwiftUI

struct AddMetaData: View {
    @Binding var name: String
    @Binding var summary: String
    @Binding var category: String
    @Binding var featured: String
    @Binding var prepTime: String
    @Binding var cookTime: String
    @Binding var totalTime: String
    @Binding var servings: String
    
    var body: some View {
        Group {
            HStack {
                Text("Name: ").bold()
                TextField("Tuna Casserole", text: $name)
            }
            
            HStack {
                Text("Summary: ").bold()
                TextField("A delicious meal for the whole family", text: $summary)
            }
            
            HStack {
                Text("Category: ").bold()
                TextField("Italian", text: $category)
            }
            
            HStack {
                Text("Prep Time: ").bold()
                TextField("1 hour", text: $prepTime)
            }
            
            HStack {
                Text("Cook Time: ").bold()
                TextField("2 hours", text: $cookTime)
            }
            
            HStack {
                Text("Total Time: ").bold()
                TextField("3 hours", text: $totalTime)
            }
            
            HStack {
                Text("Servings: ").bold()
                TextField("6", text: $servings)
            }
            
            HStack {
                Text("Featured: ").bold()
                TextField("True", text: $featured)
            }
        }
    }
}
