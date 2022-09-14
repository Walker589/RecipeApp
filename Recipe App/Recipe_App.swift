//
//  Recipe_List_App.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import SwiftUI
import Firebase

@main
struct Recipe_App: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchPage()
                .environmentObject(RecipeModel())
            
            // TODO: Rearrange Ingredients, Directions and Highlights
        }
    }
}
