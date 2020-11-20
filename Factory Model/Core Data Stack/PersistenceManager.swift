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
        let container = NSPersistentCloudKitContainer(name: containerName)
        
        /// for testing and previewing
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error loading store: \(error.localizedDescription), \(error.userInfo)")
            }
        }
        
        /// automatic syncing that happens through the silent push notification
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    init(containerName: String, inMemory: Bool = false) {
        self.containerName = containerName
        self.inMemory = inMemory
        
        /// automatically save any changes when application goes to the background
        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification
        
        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            
            self.context.saveContext()
        }
    }
}

extension PersistenceManager {

    //  MARK: Previews
    //
    static var preview: PersistenceManager = {
        let manager = PersistenceManager(containerName: "DataModel", inMemory: true)
        
        do {
            try manager.createSampleData(in: manager.context)
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return manager
    }()
    
    static var previewContext: NSManagedObjectContext {
        preview.context
    }
}

extension PersistenceManager {
    
    //  MARK: Sample Data
    //
    func createSampleData(in context: NSManagedObjectContext) throws {
        //deleteAll()
        
        let _ = Factory.createFactory1(in: context)
        let _ = Factory.createFactory2(in: context)
        
        context.saveContext()
    }
    

    //  MARK: Delete All
    //
    func deleteAll() {
        let entities = container.managedObjectModel.entities
        
        for entity in entities {
            if let entityName = entity.name {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try context.execute(deleteRequest)
                } catch let error as NSError {
                    debugPrint("Delete ERROR \(entityName)")
                    debugPrint(error.localizedDescription)
                }
            }
        }
        
        context.saveContext()
    }

    //  MARK: List of all Entities in the Model
    //
    var entitiesList: String {
        container.managedObjectModel.entities
            .compactMap { $0.name }
            .joined(separator: ", ")
    }
    
    //  MARK: Check if context contains any object
    //
    var isEmpty: Bool {
        let entities = container.managedObjectModel.entities
        var total = 0
        
        for entity in entities {
            if let entityName = entity.name {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                do {
                    let count = try context.count(for: request)
                    total += count
                } catch let error as NSError {
                    debugPrint(error.localizedDescription)
                }
            }
        }
        
        return total == 0
    }
}

