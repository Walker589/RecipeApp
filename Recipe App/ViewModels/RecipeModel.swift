//
//  RecipeModel.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class RecipeModel : ObservableObject {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @Published var loggedIn = false
    @Published var loginMode = true
    @Published var fetchedRemoteData = false
    
    @Published var profileImage: UIImage?
    @Published var userName = ""
    @Published var passwordCount = 0
    
    @Published var recipeName = ""
    @Published var ingredients = [Ingredient]()
    @Published var directions = [String]()
    @Published var cuisine = ""
    @Published var prepTime = ""
    @Published var servings = ""
    @Published var isPrivate = true
    @Published var recipeImage: UIImage?
    
    @Published var pageNumber = 1
    @Published var errorMessage = ""
    
    @Published var addIngredientLine = false
    @Published var addStep = false
    
    @Published var recipes = [Recipe]()
    
    init() {
        
    }
    
    func checkLogin() {
        self.loggedIn = Auth.auth().currentUser != nil ? true : false
    }
    
    func getRemoteData() {
        let collection = db.collection("recipes")
        
        collection.getDocuments { snapshot, error in
            print("")
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot {
                var recipes = [Recipe]()

                for doc in snapshot.documents {
                    let recipe = Recipe()

                    recipe.id = doc.documentID
                    recipe.name = doc["name"] as? String ?? ""
                    recipe.cuisine = doc["cuisine"] as? String ?? ""
                    recipe.featured = doc["featured"] as? Bool ?? false
                    recipe.prepTime = doc["prepTime"] as? String ?? ""
                    recipe.servings = doc["servings"] as? Int ?? 2
                    recipe.highlights = doc["highlights"] as? [String] ?? []
                    recipe.directions = doc["directions"] as? [String] ?? []

                    collection.document(doc.documentID).collection("ingredients").getDocuments { snapshot, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let snapshot = snapshot {
                            var ingredients = [Ingredient]()

                            for doc in snapshot.documents {
                                let ingredient = Ingredient()

                                ingredient.id = doc.documentID
                                ingredient.name = doc["name"] as? String ?? ""
                                ingredient.num = doc["num"] as? Int ?? 1
                                ingredient.denom = doc["denom"] as? Int ?? 1
                                ingredient.unit = doc["unit"] as? String ?? ""

                                ingredients.append(ingredient)
                            }
                            recipe.ingredients = ingredients
                        }
                    }

                    let storageRef = self.storage.reference().child("recipeImages/\(recipe.name.lowercased()).jpg")

                    storageRef.getData(maxSize: Int64(1000000)) { data, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let data = data {
                            recipe.image = data
                        }
                    }

                    recipes.append(recipe)
                }

                DispatchQueue.main.async {
                    self.recipes = recipes
                }
            }
            
            let collection2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").collection("recipes")
            
            collection2.getDocuments { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                } else if let snapshot = snapshot {
                    var recipes = [Recipe]()

                    for doc in snapshot.documents {
                        let recipe = Recipe()

                        recipe.id = doc.documentID
                        recipe.name = doc["name"] as? String ?? ""
                        recipe.cuisine = doc["cuisine"] as? String ?? ""
                        recipe.featured = doc["featured"] as? Bool ?? false
                        recipe.prepTime = doc["prepTime"] as? String ?? ""
                        recipe.servings = doc["servings"] as? Int ?? 2
                        recipe.highlights = doc["highlights"] as? [String] ?? []
                        recipe.directions = doc["directions"] as? [String] ?? []

                        collection2.document(doc.documentID).collection("ingredients").getDocuments { snapshot, error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else if let snapshot = snapshot {
                                var ingredients = [Ingredient]()

                                for doc in snapshot.documents {
                                    let ingredient = Ingredient()

                                    ingredient.id = doc.documentID
                                    ingredient.name = doc["name"] as? String ?? ""
                                    ingredient.num = doc["num"] as? Int ?? 1
                                    ingredient.denom = doc["denom"] as? Int ?? 1
                                    ingredient.unit = doc["unit"] as? String ?? ""

                                    ingredients.append(ingredient)
                                }
                                recipe.ingredients = ingredients
                            }
                        }

                        let storageRef = self.storage.reference().child("\(Auth.auth().currentUser?.uid ?? "")/images/\(recipe.name.lowercased()).jpg")

                        storageRef.getData(maxSize: Int64(1000000)) { data, error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else if let data = data {
                                recipe.image = data
                            }
                        }

                        recipes.append(recipe)
                    }

                    DispatchQueue.main.async {
                        self.recipes += recipes
                    }
                }
            }
            
            self.fetchedRemoteData = true
        }
    }
    
    static func getPortion(ingredient: Ingredient, recipeServings: Int, targetServings: Int) -> String {
        
        var portion = ""
        var numerator = ingredient.num ?? 1
        var denominator = ingredient.denom ?? 1
        var wholePortions = 0
        
        // Single Serving Size
        denominator *= recipeServings
        
        // Get Target Portion
        numerator *= targetServings
        
        // Reduce Fraction
        let divisor = Rational.greatestCommonDivisor(numerator, denominator)
        numerator /= divisor
        denominator /= divisor
        
        // Get Whole Portion
        if numerator >= denominator {
            
            // Calculate Whole Portions
            wholePortions = numerator / denominator
            
            // Calculate Remainder
            numerator %= denominator
            
            // Assign to Portion String
            portion += String(wholePortions)
        }
        
        // Express Remainder as Fraction
        if numerator > 0 {
            // Assign Remainder as Fraction to Portion String
            portion += wholePortions > 0 ? " " : ""
            portion += "\(numerator)/\(denominator)"
        }
        
        if var unit = ingredient.unit?.lowercased() {
            if wholePortions > 1 || (wholePortions == 1 && numerator > 0) {
                let abbreviations = ["cm", "'", "\"", "kg", "ml", "g", "mg", "m", "l", "yd", "t Mg", "t", "st", "lb", "oz", "gal", "pt", "qt", "fl oz", "tbsp", "tsp", "km", "mi"]
                // Calculate Appropriate Suffix
                if unit.suffix(1) == "s" || abbreviations.contains(unit) {
                    
                } else if unit.suffix(2) == "ch" {
                    unit += "es"
                } else if unit.suffix(1) == "f" {
                    unit = String(unit.dropLast())
                    unit += "ves"
                } else {
                    unit += "s"
                }
            }
            portion += ingredient.num == nil && ingredient.denom == nil ? "" : " "
            
            return portion + unit
        }
        
        return portion
    }
    
    func cancelAddRecipe() {
        recipeName = ""
        ingredients = [Ingredient]()
        directions = [String]()
        cuisine = ""
        prepTime = ""
        servings = ""
        recipeImage = nil
        
        addIngredientLine = false
        addStep = false
        
        pageNumber = 0
        errorMessage = ""
    }
    
    func addRecipe() {
        let cleanedRecipeName = recipeName.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedCuisine = cuisine.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPrepTime = prepTime.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedServings = servings.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedRecipeName != "" && cleanedCuisine != "" && cleanedPrepTime != "" && cleanedServings != "" && recipeImage != nil {
            let db = Firestore.firestore()
            if let currentUser = Auth.auth().currentUser {
                if self.isPrivate {
                    let users = db.collection("users")
                    let currentUserRecipes = users.document(currentUser.uid)
                    let recipes = currentUserRecipes.collection("recipes")
                    let recipeDocument = recipes.document(cleanedRecipeName)
                    
                    recipes.getDocuments { snapshot, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let snapshot = snapshot {
                            for doc in snapshot.documents {
                                if cleanedRecipeName == doc.documentID {
                                    self.errorMessage = "Recipe with same name already exists"
                                    return
                                }
                            }
                            
                            self.errorMessage = ""
                            
                            recipeDocument.setData([
                                "name" : cleanedRecipeName,
                                "directions" : self.directions,
                                "cuisine" : cleanedCuisine,
                                "prepTime" : cleanedPrepTime,
                                "servings" : Int(cleanedServings) ?? 1,
                                "featured" : false
                            ])
                            
                            let ingredientsCollection = recipeDocument.collection("ingredients")

                            for ingredient in self.ingredients {
                                ingredientsCollection.addDocument(data: [
                                    "name" : ingredient.name,
                                    "num" : ingredient.num ?? 1,
                                    "denom" : ingredient.denom ?? 1,
                                    "unit" : ingredient.unit ?? ""
                                ])
                            }
                            
                            self.errorMessage = ""
                            
                            self.uploadImage(image: self.recipeImage!, name: self.recipeName)
                        }
                    }
                } else {
                    let recipes = db.collection("recipes")
                    let recipeDocument = recipes.document(cleanedRecipeName)
                    
                    recipes.getDocuments { snapshot, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let snapshot = snapshot {
                            for doc in snapshot.documents {
                                if cleanedRecipeName == doc.documentID {
                                    self.errorMessage = "Recipe with same name already exists"
                                    return
                                }
                            }
                            
                            self.errorMessage = ""
                            
                            recipeDocument.setData([
                                "name" : cleanedRecipeName,
                                "directions" : self.directions,
                                "cuisine" : cleanedCuisine,
                                "prepTime" : cleanedPrepTime,
                                "servings" : Int(cleanedServings) ?? 1,
                                "featured" : false
                            ])
                            
                            let ingredientsCollection = recipeDocument.collection("ingredients")

                            for ingredient in self.ingredients {
                                ingredientsCollection.addDocument(data: [
                                    "name" : ingredient.name,
                                    "num" : ingredient.num ?? 1,
                                    "denom" : ingredient.denom ?? 1,
                                    "unit" : ingredient.unit ?? ""
                                ])
                            }
                            
                            self.errorMessage = ""
                            
                            self.uploadImage(image: self.recipeImage!, name: self.recipeName)
                        }
                    }
                }
            }
        } else {
            errorMessage = "Field(s) Missing"
        }
    }
    
    func uploadImage(image: UIImage, name: String, profileImage: Bool = false) {
        let storageRef = storage.reference().child("\(Auth.auth().currentUser?.uid ?? "")/\(profileImage == true ? "profile" : "recipeImages")/\(name.lowercased()).jpg")
        let data = image.jpegData(compressionQuality: 0.2)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        if let data = data {
            storageRef.putData(data, metadata: metaData) { metadata, error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getProfileImage() {
        let storageRef = storage.reference().child("\(Auth.auth().currentUser?.uid ?? "")/profile/profile image.jpg")

        storageRef.getData(maxSize: Int64(1000000)) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                self.profileImage = UIImage(data: data)
            }
        }
    }
    
    func uploadUserData(name: String, passwordCount: Int) {
        if let currentUser = Auth.auth().currentUser {
            let userDataDoc = db.collection("users").document(currentUser.uid).collection("user").document("data")
            userDataDoc.setData([
                "name" : name,
                "passwordCount" : passwordCount
            ])
        }
    }
    
    func getUserData() {
        if let currentUser = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let userDataDoc = db.collection("users").document(currentUser.uid).collection("user").document("data")
            
            userDataDoc.getDocument { document, error in
                if let error = error {
                    print(error.localizedDescription)
                } else if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        self.userName = data["name"] as? String ?? ""
                        self.passwordCount = data["passwordCount"] as? Int ?? 0
                    }
                }
            }
        }
    }
}
