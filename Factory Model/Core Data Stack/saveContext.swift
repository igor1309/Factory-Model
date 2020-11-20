//
//  saveContext.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.10.2020.
//

import CoreData

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
