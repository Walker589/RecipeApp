//
//  SearchBar.swift
//  Recipe App
//
//  Created by Ali Earp on 31/08/2022.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var filterBy: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(colorScheme == .light ? .white : Color(.darkGray))
                .cornerRadius(5)
                .shadow(radius: 5)
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Filter by...", text: $filterBy)
                    .foregroundColor(.white)
                
                Button {
                    filterBy = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
            }.padding()
        }
        .foregroundColor(colorScheme == .light ? .gray : .white)
        .frame(height: 48)
    }
}
