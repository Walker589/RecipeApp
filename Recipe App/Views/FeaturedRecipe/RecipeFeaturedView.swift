//
//  RecipeFeaturedView.swift
//  Recipe App
//
//  Created by Ali Earp on 06/08/2022.
//

import SwiftUI

struct RecipeFeaturedView: View {
    @EnvironmentObject var model: RecipeModel
    
    @State var isDetailViewShowing = false
    @State var tabSelectionIndex = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Featured Recipes")
                .bold()
                .padding(.leading)
                .font(Font.custom("Avenir Heavy", size: 24))
            
            GeometryReader { geo in
                TabView(selection: $tabSelectionIndex) {
                    ForEach(0..<model.recipes.count, id: \.self) { index in
                        if model.recipes[index].featured == true {
                            Button {
                                isDetailViewShowing = true
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.white)
                                    
                                    VStack(spacing: 0) {
                                        let image = UIImage(data: model.recipes[index].image)
                                        Image(uiImage: image ?? UIImage())
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                        
                                        Text(model.recipes[index].name)
                                            .padding(5)
                                            .font(Font.custom("Avenir", size: 15))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            .tag(index)
                            .sheet(isPresented: $isDetailViewShowing) {
                                RecipeDetailView(recipe: model.recipes[index])
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: geo.size.width - 40,
                                   height: geo.size.height - 100,
                                   alignment: .center)
                            .cornerRadius(15)
                            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5), radius: 10, x: -5, y: 5)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                FeaturedViewDetails(title: "Preperation Time", info: model.recipes[tabSelectionIndex].prepTime)
                
                Text("Highlights:")
                    .font(Font.custom("Avenir Heavy", size: 16))
                RecipeHighlightsView(highlights: model.recipes[tabSelectionIndex].highlights)
                    .font(Font.custom("Avenir", size: 15))
                
                FeaturedViewDetails(title: "Cuisine", info: model.recipes[tabSelectionIndex].cuisine)
            }
            .padding([.leading, .bottom])
            .foregroundColor(.primary)
        }.onAppear {
            setFeaturedIndex()
        }
    }
    
    func setFeaturedIndex() {
        // Find First Featured Recipe Index
        let index = model.recipes.firstIndex { recipe in
            return recipe.featured
        }
        tabSelectionIndex = index ?? 0
    }
}

struct RecipeFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeFeaturedView()
            .environmentObject(RecipeModel())
            .preferredColorScheme(.dark)
    }
}
