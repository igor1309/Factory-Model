//
//  Draft.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.08.2020.
//

import Foundation

protocol Draft: Identifiable {
    static var plural: String { get }
}
extension EmployeeDraft: Draft {
    static var plural: String { "Employees" }
}
extension RecipeDraft: Draft {
    static var plural: String { "Recipes" }
}
extension SalesDraft: Draft {
    static var plural: String { "Sales" }
}

