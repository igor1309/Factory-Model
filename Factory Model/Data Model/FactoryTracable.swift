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
        NSPredicate(
            format: format, (factoryPath), factory
        )
    }
}

extension Feedstock: FactoryTracable {
    static var format: String {
        "ANY %K.base.factory == %@"
    }
    static var factoryPath: String {
            "\(#keyPath(Feedstock.ingredients_))"
    }
}

extension Sales: FactoryTracable {
    static var format: String {
        "%K == %@"
    }

    static var factoryPath: String {
        "\(#keyPath(Sales.product.base.factory))"
    }
}
