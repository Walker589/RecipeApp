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
            
            // TODO: Add highlights
            // TODO: (Maybe) Delete recipes
            // TODO: Add name to recipes
            // TODO: Add bar at top of add recipe
        }
    }
}
