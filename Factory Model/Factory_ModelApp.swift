//
//  Factory_ModelApp.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

@main
struct Factory_ModelApp: App {
    let persistence = PersistenceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environmentObject(persistence)
                .environment(\.managedObjectContext, persistence.persistentContainer.viewContext)
        }
    }
}
