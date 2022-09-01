//
//  SearchBar.swift
//  Recipe App
//
//  Created by Ali Earp on 31/08/2022.
//

import SwiftUI

struct SearchBar: View {
    @Binding var filterBy: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(5)
                .shadow(radius: 5)
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Filter by...", text: $filterBy)
                    .foregroundColor(.black)
                
                Button {
                    filterBy = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
            }.padding()
        }
        .foregroundColor(.gray)
        .frame(height: 48)
    }
}
