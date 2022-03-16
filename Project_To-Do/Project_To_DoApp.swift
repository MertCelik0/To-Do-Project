//
//  Project_To_DoApp.swift
//  Project_To-Do
//
//  Created by Mert Çelik on 16.03.2022.
//

import SwiftUI

@main
struct Project_To_DoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
