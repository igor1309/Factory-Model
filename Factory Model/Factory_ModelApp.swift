//
//  Factory_ModelApp.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

@main
struct Factory_ModelApp: App {
    @StateObject var persistence = PersistenceManager(containerName: "DataModel")
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.context)
                .environmentObject(persistence)
        }
    }
}
