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
        guard name_ != nil else { return "ERROR: no Name" }
        return nil
    }
}
extension Validatable {
    var isValid: Bool { errorMessage == nil }
}

extension Base: Validatable {
    var errorMessage: String? {
        guard name_ != nil else { return "ERROR: no Name" }
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
        guard name_ != nil else { return "ERROR: no Name" }
        guard division != nil else { return "ERROR: no Division" }
        guard type_ != nil else { return "ERROR: no Type" }
        return nil
    }
}

extension Division: Validatable {}

extension Employee: Validatable {
    var errorMessage: String? {
        guard name_ != nil else { return "ERROR: no Name" }
        guard position_ != nil else { return "ERROR: no Position" }
        guard department != nil else { return "ERROR: no Department" }
        guard salary > 0 else { return "ERROR: no Salary" }
//        guard periodStr_ != nil else { return "ERROR: no Period" }
//        guard !(periodStr_ ?? "").isEmpty else { return "ERROR: no Period" }
        return nil
    }
}

extension Equipment: Validatable {}
extension Expenses: Validatable {}
extension Factory: Validatable {}

extension Ingredient: Validatable {
    var errorMessage: String? {
        guard name_ != nil else { return "ERROR: no Ingredient Name" }
        guard priceExVAT > 0 else { return "ERROR: no Price" }
        guard unitString_ != nil else { return "ERROR: no Unit" }
        guard !(unitString_ ?? "").isEmpty else { return "ERROR: no Unit" }
        guard vat >= 0 else { return "ERROR: no VAT" }
        return nil
    }
}

extension Recipe: Validatable {
    var errorMessage: String? {
        guard base != nil else { return "ERROR: no Base Product" }
        guard ingredient != nil else { return "ERROR: no Ingredient" }
        guard qty > 0 else { return "ERROR: no Qty" }
        guard ingredient?.unitString_ != nil else { return "ERROR: no Ingredient Unit" }
        return nil
    }
}

extension Packaging: Validatable {}

extension Product: Validatable {
    var errorMessage: String? {
        guard name_ != nil else { return "ERROR: no Name" }
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
        guard buyer != nil else { return "ERROR: no Buyer" }
        guard product != nil else { return "ERROR: no Product" }
        guard qty > 0 else { return "ERROR: no Qty" }
        guard priceExVAT > 0 else { return "ERROR: no Price" }
        return nil
    }
}

extension Utility: Validatable {}
