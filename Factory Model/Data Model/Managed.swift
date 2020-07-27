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
}
extension Managed where Self: NSManagedObject {
    static var entityName: String { return entity().name! }
    
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
}

/// https://stackoverflow.com/a/46038865
extension Managed where Self: Monikerable, ManagedType == Self {
    static func defaultFetchRequest(with predicate: NSPredicate? = nil) -> FetchRequest<Self> {
        let request = NSFetchRequest<ManagedType>(entityName: ManagedType.entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = predicate
        return FetchRequest(fetchRequest: request)
    }
}



extension Base: Managed {}
extension Buyer: Managed {}
extension Department: Managed {}
extension Equipment: Managed {}
extension Expenses: Managed {}
extension Factory: Managed {}
extension Feedstock: Managed {}
extension Ingredient: Managed {}
extension Packaging: Managed {}
extension Product: Managed {}
extension Sales: Managed {}
extension Staff: Managed {}
extension Utility: Managed {}
