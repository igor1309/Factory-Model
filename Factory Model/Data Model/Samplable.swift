//
//  Samplable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import CoreData

protocol Samplable {
    func makeSample(addTo factory: Factory, saveIn context: NSManagedObjectContext)
}

extension Base: Samplable {
    func makeSample(addTo factory: Factory, saveIn context: NSManagedObjectContext) {
        self.name = " ..."
        factory.addToBases_(self)
        context.saveContext()
    }
}

extension Equipment: Samplable {
    func makeSample(addTo factory: Factory, saveIn context: NSManagedObjectContext) {
        self.name = " ..."
        self.lifetime = 7
        self.price = 1_000_000
        
        factory.addToEquipments_(self)
        context.saveContext()
    }
}

extension Expenses: Samplable {
    func makeSample(addTo factory: Factory, saveIn context: NSManagedObjectContext) {
        self.name = " ..."
        self.note = "..."
        self.amount = 10_000
        factory.addToExpenses_(self)
        context.saveContext()
    }
}
