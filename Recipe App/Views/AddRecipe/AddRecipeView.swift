//
//  AddRecipeView.swift
//  Recipe App
//
//  Created by Ali Earp on 01/09/2022.
//

import SwiftUI
import FirebaseStorage

struct AddRecipeView: View {
    @EnvironmentObject var model: RecipeModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isShowingImagePicker = false
    @State private var image = Image(systemName: "photo.fill")
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color(.lightGray))
                        .frame(width: (geo.size.width / 4) * 3)
                    
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(width: geo.size.width / 4)
                }
            }.frame(height: 5)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Add Recipe")
                        .bold()
                        .font(Font.custom("Avenir Heavy", size: 24))
                    
                    Spacer()
                    
                    Button("Clear") {
                        model.cuisine = ""
                        model.servings = ""
                        model.prepTime = ""
                        model.recipeImage = nil
                        model.errorMessage = ""
                        image = Image(systemName: "photo.fill")
                    }
                }.padding(.top)
                
                ScrollView(showsIndicators: false) {
                    TextField("Recipe Name", text: $model.recipeName)
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding([.bottom, .horizontal])
                    
                    ZStack(alignment: .topTrailing) {
                        if image == Image(systemName: "photo.fill") {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350)
                                .foregroundColor(colorScheme == .light ? .black : Color(.darkGray))
                                .padding(.bottom)
                        } else {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 350, height: 350)
                                .cornerRadius(10)
                                .padding(.bottom)
                        }
                        
                        Button {
                            isShowingImagePicker = true
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20)
                                Text("EDIT")
                            }
                            .foregroundColor(.white)
                            .padding(20)
                        }
                        .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                            ImagePicker(recipeImage: $model.recipeImage)
                        }
                    }
                    
                    Group {
                        Group {
                            HStack {
                                Text("Ingredients")
                                Spacer()
                                Text("\(model.ingredients.count) \(model.ingredients.count == 1 ? "INGREDIENT" : "INGREDIENTS")")
                                    .bold()
                                    .foregroundColor(.green)
                            }.padding(.vertical)
                            
                            Divider()
                            
                            HStack {
                                Text("Directions")
                                Spacer()
                                Text("\(model.directions.count) \(model.directions.count == 1 ? "STEP" : "STEPS")")
                                    .bold()
                                    .foregroundColor(.green)
                            }.padding(.vertical)
                            
                            Divider()
                            
                            HStack {
                                Text("Highlights")
                                Spacer()
                                Text("\(model.highlights.count) \(model.highlights.count == 1 ? "HIGHLIGHT" : "HIGHLIGHTS")")
                                    .bold()
                                    .foregroundColor(.green)
                            }.padding(.vertical)
                            
                            Divider()
                        }
                        
                        Group {
                            HStack {
                                Text("Cuisine")
                                    .padding(.trailing)
                                Spacer()
                                TextField("Cuisine", text: $model.cuisine)
                                    .multilineTextAlignment(.trailing)
                            }.padding(.vertical)
                            
                            Divider()
                            
                            HStack {
                                Text("Servings")
                                    .padding(.trailing)
                                Spacer()
                                TextField("Servings", text: $model.servings)
                                    .multilineTextAlignment(.trailing)
                            }.padding(.vertical)
                            
                            Divider()
                            
                            HStack {
                                Text("Prep Time")
                                    .padding(.trailing)
                                Spacer()
                                TextField("Prep Time", text: $model.prepTime)
                                    .multilineTextAlignment(.trailing)
                            }.padding(.vertical)
                            
                            Divider()
                        }
                    }
                    .font(.subheadline)
                    
                    if model.errorMessage != "" {
                        Text(model.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                    }
                    
                    Button {
                        model.addRecipe()
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.green)
                                .cornerRadius(50)
                                .frame(height: 55)
                            
                            Text("Add Recipe")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding([.bottom, .horizontal], 40)
                        .padding(.top)
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .onAppear {
                loadImage()
            }
        }
    }
    
    func loadImage() {
        if model.recipeImage != nil {
            image = Image(uiImage: model.recipeImage!)
        } else {
            image = Image(systemName: "photo.fill")
        }
    }
}
