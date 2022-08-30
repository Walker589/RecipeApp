//
//  RecipeCategoryView.swift
//  Recipe App
//
//  Created by Ali Earp on 22/08/2022.
//

import SwiftUI

struct RecipeCategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var model: RecipeModel
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Categories")
                .bold()
                .padding(.top, 40)
                .font(Font.custom("Avenir Heavy", size: 24))
                .foregroundColor(.primary)
            
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.flexible(),
                                                 spacing: 20,
                                                 alignment: .top),
                                        GridItem(.flexible(),
                                                 spacing: 20,
                                                 alignment: .top)],
                              alignment: .center,
                              spacing: 20) {
                        ForEach(Array(model.categories), id: \.self) { category in
                            
                            Button {
                                selectedTab = Constants.listTab
                                model.selectedCategory = category
                            } label: {
                                VStack {
                                    Image(category.lowercased())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (geo.size.width - 20) / 2, height: (geo.size.width - 20) / 2)
                                        .cornerRadius(10)
                                        .clipped()
                                    Text(category)
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                }
                            }
                        }
                    }.padding(.bottom, 30)
                }
            }
        }.padding(.horizontal)
    }
}
