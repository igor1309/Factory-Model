//
//  Factory_ModelApp.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI

@main
struct Factory_ModelApp: App {
    @StateObject var persistence: PersistenceManager
    @StateObject var settings: Settings
    
    init() {
        /// Why create state objects using StateObject(wrappedValue:)?
        /// https://www.hackingwithswift.com/plus/ultimate-portfolio-app/questions-and-answers-part-1
        
        let persistence = PersistenceManager(containerName: "DataModel")
        _persistence = StateObject(wrappedValue: persistence)
        
        let settings = Settings()
        _settings = StateObject(wrappedValue: settings)

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.context)
                .environmentObject(persistence)
                .environmentObject(settings)
        }
    }
}
