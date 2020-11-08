//
//  FactoryTracable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import Foundation
import CoreData

protocol FactoryTracable where Self: NSManagedObject {
    static func factoryPredicate(for factory: Factory) -> NSPredicate
    
    static var format: String { get }
    static var factoryPath: String { get }
}
extension FactoryTracable {//where Self: NSManagedObject {
    static var format: String { "%K == %@" }
    static func factoryPredicate(for factory: Factory) -> NSPredicate {
        NSPredicate(format: format, (factoryPath), factory)
    }
}

extension Base: FactoryTracable {
    static var factoryPath: String { "\(#keyPath(Base.factory))" }
}

extension Buyer: FactoryTracable {
    static var factoryPath: String { "\(#keyPath(Buyer.factory))" }
}

extension Department: FactoryTracable {
    static var factoryPath: String { "\(#keyPath(Department.division.factory))" }
}

extension Division: FactoryTracable {
    static var factoryPath: String { "\(#keyPath(Division.factory))" }
}

extension Employee: FactoryTracable {
    static var factoryPath: String { "\(#keyPath(Employee.department.division.factory))" }
}

extension Equipment: FactoryTracable {
    static var factoryPath: String { "\(#keyPath(Equipment.factory))" }
}

extension Expenses: FactoryTracable {
    static var factoryPath: String { "\(#keyPath(Expenses.factory))" }
}

extension Ingredient: FactoryTracable {
    static var format: String { "ANY %K.base.factory == %@" }
    static var factoryPath: String { "\(#keyPath(Ingredient.recipes_))" }
}

extension Packaging: FactoryTracable {
    static var format: String { "ANY %K.base.factory == %@" }
    static var factoryPath: String { "\(#keyPath(Packaging.products_))" }
}

extension Product: FactoryTracable {
    static var factoryPath: String { "\(#keyPath(Product.base.factory))" }
}

extension Sales: FactoryTracable {
    static var factoryPath: String { "\(#keyPath(Sales.product.base.factory))" }
}
