//
//  FactoryChild.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import Foundation
import CoreData

/// Having a KeyPath for direct Children of Factory, immediate descendants: just 1 level deep
protocol FactoryChild where Self: FactoryTracable {//NSManagedObject {
    static var factoryToChildrenKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> { get }
}

extension Base: FactoryChild {
    static var factoryToChildrenKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> {
        \Factory.bases_
    }
}
extension Buyer: FactoryChild {
    static var factoryToChildrenKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> {
        \Factory.buyers_
    }
}
extension Division: FactoryChild {
    static var factoryToChildrenKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> {
        \Factory.divisions_
    }
}
extension Equipment: FactoryChild {
    static var factoryToChildrenKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> {
        \Factory.equipments_
    }
}
extension Expenses: FactoryChild {
    static var factoryToChildrenKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> {
        \Factory.expenses_
    }
}
