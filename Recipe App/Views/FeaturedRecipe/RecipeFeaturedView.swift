//
//  RecipeFeaturedView.swift
//  Recipe App
//
//  Created by Ali Earp on 06/08/2022.
//

import SwiftUI

struct RecipeFeaturedView: View {
    @State var isDetailViewShowing = false
    @State var tabSelectionIndex = 0
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: NSPredicate(format: "featured == true"))
    var recipes: FetchedResults<Recipe>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Featured Recipes")
                .bold()
                .padding(.leading)
                .padding(.top, 40)
                .font(Font.custom("Avenir Heavy", size: 24))
            
            GeometryReader { geo in
                TabView(selection: $tabSelectionIndex) {
                    ForEach(0..<recipes.count) { index in
                        Button {
                            self.isDetailViewShowing = true
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 0) {
                                    let image = UIImage(data: recipes[index].image ?? Data())
                                    Image(uiImage: image ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                    
                                    Text(recipes[index].name)
                                        .padding(5)
                                        .font(Font.custom("Avenir", size: 15))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .tag(index)
                        .sheet(isPresented: $isDetailViewShowing) {
                            RecipeDetailView(recipe: recipes[index])
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: geo.size.width - 40,
                               height: geo.size.height - 100,
                               alignment: .center)
                        .cornerRadius(15)
                        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5), radius: 10, x: -5, y: 5)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                FeaturedViewDetails(title: "Preperation Time", info: recipes[tabSelectionIndex].prepTime)
                
                Text("Highlights:")
                    .font(Font.custom("Avenir Heavy", size: 16))
                RecipeHighlightsView(highlights: recipes[tabSelectionIndex].highlights)
                    .font(Font.custom("Avenir", size: 15))
                
                FeaturedViewDetails(title: "Cuisine", info: recipes[tabSelectionIndex].category)
            }
            .padding([.leading, .bottom])
            .foregroundColor(.primary)
        }.onAppear {
            setFeaturedIndex()
        }
    }
    
    func setFeaturedIndex() {
        // Find First Featured Recipe Index
        let index = recipes.firstIndex { recipe in
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
