//
//  AddIngredientsView.swift
//  Recipe App
//
//  Created by Ali Earp on 02/09/2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AddIngredientsView: View {
    @EnvironmentObject var model: RecipeModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var ingredientName = ""
    @State private var unit = ""
    @State private var num = ""
    @State private var denom = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(width: geo.size.width / 4)
                    
                    Rectangle()
                        .foregroundColor(Color(.lightGray))
                        .frame(width: (geo.size.width / 4) * 3)
                }
            }.frame(height: 5)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Add Ingredients")
                        .bold()
                        .font(Font.custom("Avenir Heavy", size: 24))
                    
                    Spacer()
                    
                    Button("Clear") {
                        model.recipeName = ""
                        model.ingredients = [Ingredient]()
                        model.addIngredientLine = false
                        model.errorMessage = ""
                    }
                }.padding(.top)
                
                TextField("Recipe Name", text: $model.recipeName)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding([.bottom, .horizontal])
                
                Text("\(model.ingredients.count) \(model.ingredients.count == 1 ? "INGREDIENT" : "INGREDIENTS")")
                    .bold()
                    .font(.subheadline)
                    .padding(.top)
                Divider()
                
                if model.addIngredientLine == true {
                    AddIngredientLine(ingredientName: $ingredientName,
                                      num: $num,
                                      denom: $denom,
                                      unit: $unit)
                }
                
                VStack(alignment: .leading) {
                    ScrollView(showsIndicators: false) {
                        ForEach(0..<model.ingredients.count, id: \.self) { index in
                            HStack {
                                Text(model.ingredients[index].name)
                                    .font(.headline)
                                Spacer()
                                
                                Text(RecipeModel.getPortion(ingredient: model.ingredients[index], recipeServings: 1, targetServings: 1))
                                    .font(.headline)
                                
                                Button {
                                    model.ingredients.remove(at: index)
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 17, height: 17)
                                }.padding(.leading)
                            }.padding(.vertical, 5)
                        }
                    }
                }
                
                Divider()
                
                Button {
                    model.addIngredientLine = true
                } label: {
                    ZStack {
                        Rectangle()
                            .cornerRadius(50)
                            .foregroundColor(colorScheme == .light ? .white : .black)
                            .frame(height: 55)
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.green,
                                        lineWidth: 1))
                        
                        Text("+ Add an ingredient")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                    }
                }
                .padding([.horizontal, .bottom], 40)
                .padding(.top)
            }.padding([.horizontal, .bottom])
        }
    }
}

struct AddIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        AddIngredientsView()
    }
}
