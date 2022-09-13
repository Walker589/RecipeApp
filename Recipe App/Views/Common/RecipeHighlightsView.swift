//
//  RecipeHighlightsView.swift
//  Recipe App
//
//  Created by Ali Earp on 11/08/2022.
//

import SwiftUI

struct RecipeHighlightsView: View {
    
    var allHighlights = ""
    
    init(highlights: [String]) {
        // Build String
        for index in 0..<highlights.count {
            if index == highlights.count - 1 {
                allHighlights += highlights[index]
            } else {
                allHighlights += highlights[index] + ", "
            }
        }
    }
    
    var body: some View {
        Text(allHighlights)
            .font(Font.custom("Avenir", size: 15))
            .foregroundColor(.primary)
    }
}
