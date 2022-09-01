//
//  Recipe_List_App.swift
//  Recipe List App
//
//  Created by Ali Earp on 03/08/2022.
//

import SwiftUI

@main
struct Recipe_App: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            RecipeTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
