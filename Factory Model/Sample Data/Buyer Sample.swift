//
//  Buyer Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 05.11.2020.
//

import CoreData

extension Buyer {
    
    static var example: Buyer {
        let preview = PersistenceManager.previewContext
        let request = NSFetchRequest<Buyer>(entityName: "Buyer")
        request.predicate = NSPredicate(format: "name_ == %@", "Speelo Group")
        let buyers = try? preview.fetch(request)
        if let buyer = buyers?.first {
            return buyer
        } else {
            return Buyer.createSpeeloGroup(in: preview)
        }
    }
    
    static func createSpeeloGroup(in context: NSManagedObjectContext) -> Buyer {
        let buyer = Buyer(context: context)
        buyer.name = "Speelo Group"
        
        context.saveContext()
        
        return buyer
    }
}
