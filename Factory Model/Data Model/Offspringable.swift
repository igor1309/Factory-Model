//
//  Offspringable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import Foundation
import CoreData

protocol Offspringable where Self: NSManagedObject {
//    associatedtype Parent: NSManagedObject
    static var offspringKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> { get }
}

extension Buyer: Offspringable {
    static var offspringKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> {
        \Factory.buyers_
    }
}
extension Division: Offspringable {
    static var offspringKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> {
        \Factory.divisions_
    }
}
extension Equipment: Offspringable {
    static var offspringKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> {
        \Factory.equipments_
    }
}
extension Expenses: Offspringable {
    static var offspringKeyPath: ReferenceWritableKeyPath<Factory, NSSet?> {
        \Factory.expenses_
    }
}

//Feedstock
