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
    }
    
    
    func createSampleData() throws {
        let _ = Factory.createFactory1(in: context)
        let _ = Factory.createFactory2(in: context)
        
        context.saveContext()
    }

    //  MARK: - Previews
    
    static var preview: NSManagedObjectContext = {
        let manager = PersistenceManager(containerName: "DataModel", inMemory: true)
        
        do {
            try manager.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return manager.context
    }()
    
    static var factoryPreview: Factory {
        let request = NSFetchRequest<Factory>(entityName: "Factory")
        let factories = try? preview.fetch(request)
        if let factory = factories?.first {
            return factory
        } else {
            return Factory.createFactory1(in: preview)
        }
    }
    
    static var departmentPreview: Department {
        let request = NSFetchRequest<Department>(entityName: "Department")
        let departments = try? preview.fetch(request)
        if let department = departments?.first {
            return department
        } else {
            return Department.createDepartment2(in: preview)
        }
    }
    
    static var basePreview: Base {
        let request = NSFetchRequest<Base>(entityName: "Base")
        let bases = try? preview.fetch(request)
        if let base = bases?.first {
            return base
        } else {
            return Base.createBaseKhinkali(in: preview)
        }
    }
    
    static var productPreview: Product {
        let request = NSFetchRequest<Product>(entityName: "Product")
        let products = try? preview.fetch(request)
        if let product = products?.first {
            return product
        } else {
            return Product.createProduct2_1(in: preview)
        }
    }
}

