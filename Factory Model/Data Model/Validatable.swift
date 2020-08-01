//
//  Validatable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

protocol Validatable {
    var isValid: Bool { get }
}
extension Validatable where Self: Summarizable {
    var isValid: Bool {
        let hasError = self.detail?.hasPrefix("ERROR") ?? true
        return !hasError
    }
}

extension Base: Validatable {}
extension Buyer: Validatable {}
extension Department: Validatable {}
extension Division: Validatable {}
extension Equipment: Validatable {}
extension Expenses: Validatable {}
extension Factory: Validatable {}
extension Feedstock: Validatable {}
extension Ingredient: Validatable {}
extension Packaging: Validatable {}

extension Product: Validatable {
    var isValid: Bool {
        guard self.base != nil else { return false }
        guard self.packaging != nil else { return false }
        guard self.baseQty > 0 else { return false }
        guard self.vat >= 0 else { return false }
        return true
    }

}

extension Sales: Validatable {
    var isValid: Bool {
        guard self.buyer != nil else { return false }
        guard self.product != nil else { return false }
        guard self.qty > 0 else { return false }
        guard self.priceExVAT > 0 else { return false }
        return true
    }
}

extension Utility: Validatable {}
extension Worker: Validatable {}
