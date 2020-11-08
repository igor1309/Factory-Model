//
//  Equipment Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import CoreData

extension Equipment {
    static var example: Equipment {
        let preview = PersistenceManager.previewContext
        return createSampleEquipment(in: preview)
    }
    
    static func createSampleEquipment(in context: NSManagedObjectContext) -> Equipment {
        let equipment = Equipment(context: context)
        equipment.name = "Сырная линия"
        equipment.note = "Основная производственная линия"
        equipment.price = 7_000_000
        equipment.lifetime = 7
     
        context.saveContext()
        
        return equipment
    }
}
