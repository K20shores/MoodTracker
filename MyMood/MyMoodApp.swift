//
//  MyMoodApp.swift
//  MyMood
//
//  Created by Kyle Shores on 1/2/22.
//

import SwiftUI

@main
struct MyMoodApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Homescreen(calendar: Calendar(identifier: .gregorian))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
