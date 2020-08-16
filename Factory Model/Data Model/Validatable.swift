//
//  Validatable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

protocol Validatable {
    var isValid: Bool { get }
    var errorMessage: String? { get }
}
extension Validatable where Self: Monikerable {
    var errorMessage: String? {
        guard name_ != nil else { return "ERROR: no name" }
        return nil
    }
}
extension Validatable {
    var isValid: Bool { errorMessage == nil }
}

extension Base: Validatable {
    var errorMessage: String? {
        guard name_ != nil else { return "ERROR: no name" }
        guard unitString_ != nil else { return "ERROR: no unit" }
        guard recipes_ != nil else { return "ERROR: no recipes" }
        guard weightNetto > 0 else { return "ERROR: no Weight Netto" }
        guard code_ != nil else { return "ERROR: no code" }
        guard group_ != nil else { return "ERROR: no group" }
        guard factory != nil else { return "ERROR: no factory" }
        return nil
    }
}

extension Buyer: Validatable {}

extension Department: Validatable {
    var errorMessage: String? {
        guard name_ != nil else { return "ERROR: no name" }
        guard division_ != nil else { return "ERROR: no division" }
        guard type_ != nil else { return "ERROR: no type" }
        return nil
    }
}
extension Division: Validatable {}
extension Equipment: Validatable {}
extension Expenses: Validatable {}
extension Factory: Validatable {}

extension Ingredient: Validatable {
    var errorMessage: String? {
        guard name_ != nil else { return "ERROR: no ingredient name" }
        guard priceExVAT > 0 else { return "ERROR: no price" }
        guard unitString_ != nil else { return "ERROR: no unit" }
        guard !(unitString_ ?? "").isEmpty else { return "ERROR: no unit" }
        guard vat >= 0 else { return "ERROR: no VAT" }
        return nil
    }
}

extension Recipe: Validatable {
    var errorMessage: String? {
        guard base != nil else { return "ERROR: no base product" }
        guard ingredient != nil else { return "ERROR: ingredient" }
        guard qty > 0 else { return "ERROR: no qty" }
        guard ingredient?.unitString_ != nil else { return "ERROR: no ingredient unit" }
        return nil
    }
}

extension Packaging: Validatable {}

extension Product: Validatable {
    var errorMessage: String? {
        guard name_ != nil else { return "ERROR: no name" }
        guard coefficientToParentUnit > 0 else { return "ERROR: unit coefficient" }
        guard base != nil else { return "ERROR: no base product" }
        guard baseQty > 0 else { return "ERROR: no base qty" }
        guard vat >= 0 else { return "ERROR: no VAT" }
        guard packaging != nil else { return "ERROR: no packaging" }
        guard code_ != nil else { return "ERROR: no code" }
        guard group_ != nil else { return "ERROR: no group" }
        return nil
    }
}

extension Sales: Validatable {
    var errorMessage: String? {
        guard buyer != nil else { return "ERROR: no buyer" }
        guard product != nil else { return "ERROR: no product" }
        guard qty > 0 else { return "ERROR: no qty" }
        guard priceExVAT > 0 else { return "ERROR: no price" }
        return nil
    }
}

extension Utility: Validatable {}
extension Employee: Validatable {}
