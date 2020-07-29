//
//  Orphanable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.07.2020.
//

import Foundation
import CoreData

/// fetching entities without parant (parent is nil)
protocol Orphanable {
    associatedtype ManagedType: NSManagedObject = Self
    
    static var orphanPredicate: NSPredicate { get }
    func fetchOrphans() -> [ManagedType]
}

extension Orphanable where Self: Managed, ManagedType == Self {
    func fetchOrphans() -> [ManagedType] {
        let request = ManagedType.defaultNSFetchRequest(with: ManagedType.orphanPredicate)
        if let context = self.managedObjectContext {
            let results = (try? context.fetch(request)) ?? []
            return results
        }
        return []
    }
}

extension Base: Orphanable {
    static var orphanPredicate: NSPredicate { NSPredicate(format: "factory == nil") }
}
extension Department: Orphanable {
    static var orphanPredicate: NSPredicate { NSPredicate(format: "factory == nil") }
}
extension Equipment: Orphanable {
    static var orphanPredicate: NSPredicate { NSPredicate(format: "factory == nil") }
}
extension Expenses: Orphanable {
    static var orphanPredicate: NSPredicate { NSPredicate(format: "factory == nil") }
}
extension Staff: Orphanable {
    static var orphanPredicate: NSPredicate { NSPredicate(format: "factory == nil") }
}
