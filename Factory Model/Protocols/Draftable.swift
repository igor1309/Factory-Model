//
//  Draftable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.08.2020.
//

import Foundation

protocol Draftable: Identifiable {
    static var plural: String { get }
}
extension EmployeeDraft: Draftable {
    static var plural: String { "Employees" }
}
extension RecipeDraft: Draftable {
    static var plural: String { "Recipes" }
}
extension SalesDraft: Draftable {
    static var plural: String { "Sales" }
}

