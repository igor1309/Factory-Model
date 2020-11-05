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
        let container = NSPersistentCloudKitContainer(name: containerName)// NSPersistentContainer(name: containerName)
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error loading store: \(error.localizedDescription), \(error.userInfo)")
            }
        }
        return container
    }()
    
    
    init(containerName: String, inMemory: Bool = false) {
        self.containerName = containerName
        self.inMemory = inMemory
        
        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification
        
        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            
            self.context.saveContext()
        }
    }
}

extension PersistenceManager {
    
    //  MARK: - Sample Data
    
    func createSampleData(in context: NSManagedObjectContext) throws {
        //deleteAll()
        
        let _ = Factory.createFactory1(in: context)
        let _ = Factory.createFactory2(in: context)
        
        context.saveContext()
    }
    
    //  MARK: - Previews
    
    static var previewContext: NSManagedObjectContext = {
        let manager = PersistenceManager(containerName: "DataModel", inMemory: true)
        
        do {
            try manager.createSampleData(in: manager.context)
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return manager.context
    }()
    

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
    }
    
    //  MARK: - FINISH THIS - NOT WORKING
    func deleteAllTOFIX() {
        
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Base.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Buyer.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
        
        let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = Department.fetchRequest()
        let batchDeleteRequest3 = NSBatchDeleteRequest(fetchRequest: fetchRequest3)
        _ = try? container.viewContext.execute(batchDeleteRequest3)
        
        let fetchRequest4: NSFetchRequest<NSFetchRequestResult> = Division.fetchRequest()
        let batchDeleteRequest4 = NSBatchDeleteRequest(fetchRequest: fetchRequest4)
        _ = try? container.viewContext.execute(batchDeleteRequest4)
        
        let fetchRequest5: NSFetchRequest<NSFetchRequestResult> = Employee.fetchRequest()
        let batchDeleteRequest5 = NSBatchDeleteRequest(fetchRequest: fetchRequest5)
        _ = try? container.viewContext.execute(batchDeleteRequest5)
        
        let fetchRequest6: NSFetchRequest<NSFetchRequestResult> = Equipment.fetchRequest()
        let batchDeleteRequest6 = NSBatchDeleteRequest(fetchRequest: fetchRequest6)
        _ = try? container.viewContext.execute(batchDeleteRequest6)
        
        let fetchRequest7: NSFetchRequest<NSFetchRequestResult> = Expenses.fetchRequest()
        let batchDeleteRequest7 = NSBatchDeleteRequest(fetchRequest: fetchRequest7)
        _ = try? container.viewContext.execute(batchDeleteRequest7)
        
        let fetchRequest8: NSFetchRequest<NSFetchRequestResult> = Factory.fetchRequest()
        let batchDeleteRequest8 = NSBatchDeleteRequest(fetchRequest: fetchRequest8)
        _ = try? container.viewContext.execute(batchDeleteRequest8)
        
        let fetchRequest9: NSFetchRequest<NSFetchRequestResult> = Ingredient.fetchRequest()
        let batchDeleteRequest9 = NSBatchDeleteRequest(fetchRequest: fetchRequest9)
        _ = try? container.viewContext.execute(batchDeleteRequest9)
        
        let fetchRequest10: NSFetchRequest<NSFetchRequestResult> = Packaging.fetchRequest()
        let batchDeleteRequest10 = NSBatchDeleteRequest(fetchRequest: fetchRequest10)
        _ = try? container.viewContext.execute(batchDeleteRequest10)
        
        let fetchRequest11: NSFetchRequest<NSFetchRequestResult> = Product.fetchRequest()
        let batchDeleteRequest11 = NSBatchDeleteRequest(fetchRequest: fetchRequest11)
        _ = try? container.viewContext.execute(batchDeleteRequest11)
        
        let fetchRequest12: NSFetchRequest<NSFetchRequestResult> = Recipe.fetchRequest()
        let batchDeleteRequest12 = NSBatchDeleteRequest(fetchRequest: fetchRequest12)
        _ = try? container.viewContext.execute(batchDeleteRequest12)
        
        let fetchRequest13: NSFetchRequest<NSFetchRequestResult> = Sales.fetchRequest()
        let batchDeleteRequest13 = NSBatchDeleteRequest(fetchRequest: fetchRequest13)
        _ = try? container.viewContext.execute(batchDeleteRequest13)
        
        let fetchRequest14: NSFetchRequest<NSFetchRequestResult> = Utility.fetchRequest()
        let batchDeleteRequest14 = NSBatchDeleteRequest(fetchRequest: fetchRequest14)
        _ = try? container.viewContext.execute(batchDeleteRequest14)
    }
    
}

