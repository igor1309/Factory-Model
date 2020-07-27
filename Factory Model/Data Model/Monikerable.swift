//
//  Monikerable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import Foundation

protocol Monikerable {
    var name: String { get set }
}

extension Base: Monikerable {}
extension Department: Monikerable {}
extension Equipment: Monikerable {}
extension Expenses: Monikerable {}
extension Factory: Monikerable {}
extension Feedstock: Monikerable {}
//extension Ingredient: Monikerable { var name: String { qty.formattedGrouped } }
extension Packaging: Monikerable {}
extension Product: Monikerable {}

extension Sales: Monikerable {
    var name: String {
        get { buyer }
        set { buyer_ = newValue }
    }
}

extension Staff: Monikerable {}
extension Utility: Monikerable {}
