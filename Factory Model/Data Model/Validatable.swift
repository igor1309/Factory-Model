//
//  Validatable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

protocol Validatable {
    var isValid: Bool { get }
    var validationMessage: String { get }
}
extension Validatable where Self: Summarizable {
    var isValid: Bool {
        let hasError = detail?.hasPrefix("ERROR") ?? true
        return !hasError
    }
    var validationMessage: String {
        ((detail?.hasPrefix("ERROR")) != nil) ? "ERROR" : "OK"
    }
}

extension Base: Validatable {
    var isValid: Bool {
        guard code_ != nil else { return false }
        guard group_ != nil else { return false }
        guard name_ != nil else { return false }
        guard unit_ != nil else { return false }
        guard weightNetto > 0 else { return false }
        guard factory != nil else { return false }
        guard ingredients_ != nil else { return false }
        return true
    }
    var validationMessage: String {
        guard code_ != nil else { return "ERROR: no code" }
        guard group_ != nil else { return "ERROR: no group" }
        guard name_ != nil else { return "ERROR: no name" }
        guard unit_ != nil else { return "ERROR: no unit" }
        guard weightNetto > 0 else { return "ERROR: no Weight Netto" }
        guard factory != nil else { return "ERROR: no factory" }
        guard ingredients_ != nil else { return "ERROR: no ingredients" }
        return "Base Product is OK"
    }
}

extension Buyer: Validatable {}
extension Department: Validatable {}
extension Division: Validatable {}
extension Equipment: Validatable {}
extension Expenses: Validatable {}
extension Factory: Validatable {}

extension Feedstock: Validatable {
    var isValid: Bool {
        guard name_ != nil else { return false }
        guard priceExVAT > 0 else { return false }
        guard unit_ != nil else { return false }
        guard vat >= 0 else { return false }
        return true
    }
    var validationMessage: String {
        guard name_ != nil else { return "ERROR: no feedstock name" }
        guard priceExVAT > 0 else { return "ERROR: no price" }
        guard unit_ != nil else { return "ERROR: no unit" }
        guard vat >= 0 else { return "ERROR: no VAT" }
        return "Feedstock is OK"
    }
}

extension Ingredient: Validatable {
    var isValid: Bool {
        guard base != nil else { return false }
        guard feedstock != nil else { return false }
        guard qty > 0 else { return false }
        guard unit_ != nil else { return false }
        return true
    }
    var validationMessage: String {
        guard base != nil else { return "ERROR: no base product" }
        guard feedstock != nil else { return "ERROR: feedstock" }
        guard qty > 0 else { return "ERROR: no qty" }
        guard unit_ != nil else { return "ERROR: no unit" }
        return "Ingredient is OK"
    }
}

extension Packaging: Validatable {}

extension Product: Validatable {
    var isValid: Bool {
        guard base != nil else { return false }
        guard packaging != nil else { return false }
        guard baseQty > 0 else { return false }
        guard vat >= 0 else { return false }
        return true
    }
    var validationMessage: String {
        guard base != nil else { return "ERROR: no base product" }
        guard packaging != nil else { return "ERROR: no packaging" }
        guard baseQty > 0 else { return "ERROR: no base qty" }
        guard vat >= 0 else { return "ERROR: no VAT" }
        return "Product is OK"
    }
}

extension Sales: Validatable {
    var isValid: Bool {
        guard buyer != nil else { return false }
        guard product != nil else { return false }
        guard qty > 0 else { return false }
        guard priceExVAT > 0 else { return false }
        return true
    }
    var validationMessage: String {
        guard buyer != nil else { return "ERROR: no buyer" }
        guard product != nil else { return "ERROR: no product" }
        guard qty > 0 else { return "ERROR: no qty" }
        guard priceExVAT > 0 else { return "ERROR: no price" }
        return "Sales is OK"
    }
}

extension Utility: Validatable {}
extension Worker: Validatable {}
