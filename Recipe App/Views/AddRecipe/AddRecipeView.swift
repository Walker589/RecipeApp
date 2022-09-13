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
    
    @State private var isShowingImagePicker = false
    @State private var image = Image(systemName: "photo.fill")
    
    var body: some View {
        VStack {
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
            }
            
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
                    } else {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 350)
                            .cornerRadius(10)
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
                        
                        HStack {
                            Text("Access")
                                .padding(.trailing)
                            Picker("access", selection: $model.isPrivate) {
                                Text("Private").tag(true)
                                Text("Public").tag(false)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.leading, 75)
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
                            .bold()
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
    
    func loadImage() {
        if model.recipeImage != nil {
            image = Image(uiImage: model.recipeImage!)
        } else {
            image = Image(systemName: "photo.fill")
        }
    }
}
