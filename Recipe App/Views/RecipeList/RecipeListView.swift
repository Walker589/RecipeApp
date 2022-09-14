//
//  ContentView.swift
//  Recipe App
//
//  Created by Ali Earp on 03/08/2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct RecipeListView: View {
    @EnvironmentObject var model: RecipeModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var filterBy = ""
    let nonRemovables = ["Baked Teriyaki Chicken", "Mushroom Risotto", "Eggplant Parmesan"]
    
    private var filteredRecipes: [Recipe] {
        if filterBy.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return model.recipes
        } else {
            return model.recipes.filter { recipe in
                return recipe.name.lowercased().contains(filterBy.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("All Recipes")
                    .bold()
                    .font(Font.custom("Avenir Heavy", size: 24))
                    .foregroundColor(.primary)
                    .padding(.top)
                
                SearchBar(filterBy: $filterBy)
                    .padding([.trailing, .bottom])
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(0..<filteredRecipes.count, id: \.self) { index in
                            HStack {
                                NavigationLink {
                                    RecipeDetailView(recipe: filteredRecipes[index])
                                } label: {
                                    HStack(spacing: 20) {
                                        let image = UIImage(data: filteredRecipes[index].image)
                                        Image(uiImage: image ?? UIImage())
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50, alignment: .center)
                                            .clipped()
                                            .cornerRadius(5)
                                        
                                        VStack(alignment: .leading) {
                                            Text(filteredRecipes[index].name)
                                                .foregroundColor(.primary)
                                                .font(Font.custom("Avenir Heavy", size: 16))
                                            RecipeHighlightsView(highlights: filteredRecipes[index].highlights)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                if !nonRemovables.contains(filteredRecipes[index].name) {
                                    Button {
                                        let db = Firestore.firestore()
                                        if let currentUser = Auth.auth().currentUser {
                                            let collection = db.collection("users").document(currentUser.uid).collection("recipes")
                                            collection.getDocuments { snapshot, error in
                                                if let error = error {
                                                    print(error.localizedDescription)
                                                } else if let snapshot = snapshot {
                                                    for doc in snapshot.documents {
                                                        if doc.documentID == filteredRecipes[index].name {
                                                            collection.document(doc.documentID).delete()
                                                            let storage = Storage.storage()
                                                            let imageRef = storage.reference().child("recipeImages/\(filteredRecipes[index].name.lowercased())")
                                                            
                                                            let removeIndex = model.recipes.firstIndex { recipe in
                                                                recipe.name == filteredRecipes[index].name
                                                            }
                                                            if removeIndex != nil {
                                                                model.recipes.remove(at: removeIndex!)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .padding(.trailing)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .padding(.leading)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}
