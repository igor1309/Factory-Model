//
//  PersistenceManager.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import SwiftUI
import CoreData


class PersistenceManager: ObservableObject {
    
    private let containerName: String
    private let inMemory: Bool
    
    var context: NSManagedObjectContext { container.viewContext }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error loading store: \(error.localizedDescription), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var preview: NSManagedObjectContext = {
        let manager = PersistenceManager(containerName: "DataModel", inMemory: true)
        
        do {
            try manager.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return manager.context
    }()
    
    init(containerName: String, inMemory: Bool = false) {
        self.containerName = containerName
        self.inMemory = inMemory
        
        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification
        
        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            
            if self.container.viewContext.hasChanges {
                try? self.container.viewContext.save()
            }
        }
        
        //  MARK: - FOR TESTING!
        //  print(persistentContainer.managedObjectModel.entitiesByName)
//        for entity in persistentContainer.managedObjectModel.entitiesByName {
//            if let name = entity.value.managedObjectClassName {
//                print(name)
//                if let className = NSClassFromString(name) {
//                    print("className \(className)")
//                }
//            }
//        }
    }
    
    func createSampleData() throws {
        let _ = Factory.createFactory1(in: context)
        let _ = Factory.createFactory2(in: context)
        
        context.saveContext()
    }
}

extension NSManagedObjectContext {
    func saveContext() {
        guard hasChanges else { return }
        
        do {
            try self.save()
        } catch {
            // handle the Core Data error
            let error = error as NSError
            fatalError("Unresolved error saving context: \(error.localizedDescription), \(error.userInfo)")
        }
    }
}
