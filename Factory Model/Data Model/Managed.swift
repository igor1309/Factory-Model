//
//  Managed.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import Foundation
import CoreData

/// https://stackoverflow.com/a/51197659
protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
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
