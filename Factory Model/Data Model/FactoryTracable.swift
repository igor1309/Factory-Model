//
//  FactoryTracable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import Foundation
import CoreData

protocol FactoryTracable {
    static func factoryPredicate(for factory: Factory) -> NSPredicate
    
    static var format: String { get }
    static var factoryPath: String { get }
}
extension FactoryTracable where Self: NSManagedObject {
    static func factoryPredicate(for factory: Factory) -> NSPredicate {
        //  MARK: - not type-safe
        /// see Building compile-time type-checked NSPredicate using KeyPath and operators in Swift | by Lazar Otasevic | Medium
        /// https://medium.com/@redhotbits/building-nspredicate-with-swift-keypaths-and-operators-5ff569db304f
        
        NSPredicate(
            format: format, (factoryPath), factory
        )
    }
}

extension Feedstock: FactoryTracable {
    @objc static var factoryPath: String {
        "\(#keyPath(Feedstock.ingredients_))"
    }
    static var format: String {
        "ANY %K.base.factory == %@"
    }
}
