//
//  Monikerable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import Foundation
import CoreData

protocol Monikerable where Self: NSManagedObject {
    dynamic var name_: String? { get set }
    var name: String { get set }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}
extension Monikerable {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name_", ascending: true)]
    }
}

extension Base: Monikerable {}
extension Buyer: Monikerable {}
extension Department: Monikerable {}
extension Division: Monikerable {}
extension Equipment: Monikerable {}
extension Expenses: Monikerable {}
extension Factory: Monikerable {}
extension Feedstock: Monikerable {}
extension Ingredient: Monikerable {}
extension Packaging: Monikerable {}
extension Product: Monikerable {}
extension Sales: Monikerable {}
extension Utility: Monikerable {}
extension Worker: Monikerable {}
