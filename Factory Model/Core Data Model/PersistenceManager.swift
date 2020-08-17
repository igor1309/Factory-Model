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
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init(containerName: String) {
        self.containerName = containerName
        
        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification
        
        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            
            if self.persistentContainer.viewContext.hasChanges {
                try? self.persistentContainer.viewContext.save()
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
}

extension NSManagedObjectContext {
    func saveContext() {
        guard hasChanges else { return }
        
        do {
            try self.save()
        } catch {
            // handle the Core Data error
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
