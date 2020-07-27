//
//  Validatable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

protocol Validatable {
    var isValid: Bool { get }
}
extension Validatable where Self: Summarable {
    var isValid: Bool {
        let hasError = self.detail?.hasPrefix("ERROR") ?? true
        return !hasError
    }
}

extension Base: Validatable {}
extension Buyer: Validatable {}
extension Department: Validatable {}
extension Equipment: Validatable {}
extension Expenses: Validatable {}
extension Factory: Validatable {}
extension Feedstock: Validatable {}
extension Ingredient: Validatable {}
extension Packaging: Validatable {}
extension Product: Validatable {}
extension Sales: Validatable {}
extension Staff: Validatable {}
extension Utility: Validatable {}
