//
//  AddRecipeView.swift
//  Recipe App
//
//  Created by Ali Earp on 31/08/2022.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var tabSelection: Int
    
    @State private var name = ""
    @State private var summary = ""
    @State private var category = ""
    @State private var featured = ""
    @State private var prepTime = ""
    @State private var cookTime = ""
    @State private var totalTime = ""
    @State private var servings = ""
    
    @State private var highlights = [String]()
    @State private var directions = [String]()
    
    @State private var ingredients = [IngredientJSON]()
    
    @State private var recipeImage: UIImage?
    
    @State private var isShowingImagePicker = false
    @State private var selectedImageSource = UIImagePickerController.SourceType.photoLibrary
    @State private var image = Image("noImageAvailable")
    
    var body: some View {
        VStack {
            HStack {
                Button("Clear") {
                    clearAllFields()
                }
                Spacer()
                Button("Add") {
                    addRecipe()
                    tabSelection = Constants.listTab
                }
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    image
                        .resizable()
                        .scaledToFit()
                    
                    HStack {
                        Button("Photo Library") {
                            selectedImageSource = .photoLibrary
                            isShowingImagePicker = true
                        }
                        
                        Text(" | ")
                        
                        Button("Camera") {
                            selectedImageSource = .camera
                            isShowingImagePicker = true
                        }
                    }
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                        ImagePicker(selectedSource: selectedImageSource, recipeImage: $recipeImage)
                    }
                    
                    AddMetaData(name: $name,
                                summary: $summary,
                                category: $category,
                                featured: $featured,
                                prepTime: $prepTime,
                                cookTime: $cookTime,
                                totalTime: $totalTime,
                                servings: $servings)
                    
                    AddListData(list: $highlights, title: "Highlights", placeholderText: "Vegetarian")
                    AddListData(list: $directions, title: "Directions", placeholderText: "Add the oil to the pan")
                    
                    AddIngredientData(ingredients: $ingredients)
                }
            }
        }.padding(.horizontal)
    }
    
    func loadImage() {
        if recipeImage != nil {
            image = Image(uiImage: recipeImage!)
        }
    }
    
    func clearAllFields() {
        name = ""
        summary = ""
        category = ""
        featured  = ""
        prepTime = ""
        cookTime = ""
        totalTime = ""
        servings = ""
        
        highlights = [String]()
        directions = [String]()
        
        ingredients = [IngredientJSON]()
        
        image = Image("noImageAvailable")
    }
    
    func addRecipe() {
        let recipe = Recipe(context: viewContext)
        recipe.id = UUID()
        recipe.name = name
        recipe.category = category
        recipe.summary = summary
        recipe.category = category
        if featured.lowercased() == "true" {
            recipe.featured = true
        } else {
            recipe.featured = false
        }
        recipe.prepTime = prepTime
        recipe.cookTime = cookTime
        recipe.totalTime = totalTime
        recipe.servings = Int(servings) ?? 1
        
        recipe.highlights = highlights
        recipe.directions = directions
        
        recipe.image = recipeImage?.pngData()
        
        for i in ingredients {
            let ingredient = Ingredient(context: viewContext)
            ingredient.id = UUID()
            ingredient.name = i.name
            ingredient.unit = i.unit
            ingredient.num = i.num ?? 1
            ingredient.denom = i.denom ?? 1
            
            recipe.addToIngredients(ingredient)
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
