//
//  Managed.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import SwiftUI
import CoreData

/// https://stackoverflow.com/a/51197659
protocol Managed: class, NSFetchRequestResult {
    associatedtype ManagedType: NSManagedObject = Self
    
    static var entityName: String { get }
    
    static func defaultFetchRequest(with predicate: NSPredicate?) -> FetchRequest<ManagedType>
    static func defaultNSFetchRequest(with predicate: NSPredicate?) -> NSFetchRequest<ManagedType>
}
extension Managed where Self: NSManagedObject {
    static var entityName: String { return entity().name! }
    
    //  MARK: - FINISH THIS COULD BE MADE WITHOUT PASSING THE NSManagedObjectContext
    static func fetch(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>) -> ()) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        return try! context.fetch(request)
    }
    
    /// https://stackoverflow.com/a/27112385
    static func create(in context: NSManagedObjectContext) -> Self {
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        return unsafeDowncast(object, to: self)
    }
    
    //  MARK: - FINISH THIS return plural forms
    /// https://medium.com/@vitaliikuznetsov/plurals-localization-using-stringsdict-in-ios-a910aab8c28c
    /// https://stackoverflow.com/questions/30207436/dynamic-strings-with-placeholders-and-plural-support-in-swift-ios
    /// https://crunchybagel.com/localizing-plurals-in-ios-development/
    
    static func plural() -> String {
        switch entityName {
            case "Base":
                return "Bases"
            case "Buyer":
                return "Buyers"
            case "Department":
                return "Departments"
            case "Division":
                return "Divisions"
            case "Equipment":
                return "Equipment"
            case "Expenses":
                return "Expenses"
            case "Factory":
                return "Factories"
            case "Feedstock":
                return "Feedstocks"
            case "Ingredient":
                return "Ingredients"
            case "Packaging":
                return "Packaging"
            case "Product":
                return "Products"
            case "Sales":
                return "Sales"
            case "Utility":
                return "Utilities"
            case "Worker":
                return "Personnel"
            default:
                return entityName
        }
    }
}

/// https://stackoverflow.com/a/46038865
extension Managed where Self: Monikerable, ManagedType == Self {
    static func defaultFetchRequest(with predicate: NSPredicate? = nil) -> FetchRequest<Self> {
        FetchRequest(fetchRequest: defaultNSFetchRequest(with: predicate))
    }
    static func defaultNSFetchRequest(with predicate: NSPredicate? = nil) -> NSFetchRequest<Self> {
        let request = NSFetchRequest<ManagedType>(entityName: ManagedType.entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = predicate
        return request
    }
}

extension Managed where Self: Monikerable & FactoryTracable, ManagedType == Self {
    static func defaultFetchRequest(for factory: Factory) -> FetchRequest<Self> {
        let request = NSFetchRequest<ManagedType>(entityName: ManagedType.entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = ManagedType.factoryPredicate(for: factory)
        return FetchRequest(fetchRequest: request)
    }
}




extension Base: Managed {}
extension Buyer: Managed {}
extension Department: Managed {}
extension Division: Managed {}
extension Equipment: Managed {}
extension Expenses: Managed {}
extension Factory: Managed {}
extension Feedstock: Managed {}
extension Ingredient: Managed {}
extension Packaging: Managed {}
extension Product: Managed {}
extension Sales: Managed {}
extension Utility: Managed {}
extension Worker: Managed {}
