//
//  Summarable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

protocol Summarizable {
    var title: String { get }
    var subtitle: String { get }
    var detail: String? { get }
    
    static var color: Color { get }
    static var icon: String { get }
    static var plusButtonIcon: String { get }
    static var headline: String { get }
}
extension Summarizable where Self: Monikerable {
    var title: String {
        name.isEmpty ? "ERROR: no name" : name
    }
}
extension Summarizable {
    static var color: Color { .accentColor }
    static var plusButtonIcon: String { "plus" }
}
extension Summarizable where Self: Laborable & Productable {
    var subtitle: String {
        guard revenueExVAT > 0, productionQty > 0 else {
            return "No Sales or/and Production"
        }

        return """
Sales / Production, t: \(salesWeightNetto.formattedGroupedWith1Decimal) / \(productionWeightNetto.formattedGroupedWith1Decimal)
Work Hours: \(productionWorkHours.formattedGrouped) (\(workHours.formattedGrouped))
Revenue: \(revenueExVAT.formattedGrouped)

\nTBD: Base products with production volume (in their units): Сулугуни (10,000), Хинкали(15,000)
"""
    }
}
extension Summarizable where Self: Validatable {
    var detail: String? { errorMessage }
}
extension Summarizable where Self: Managed {
    static var headline: String {
        "Create \(Self.entityName.lowercased())."
    }
}


extension Base: Summarizable {
    var title: String {
        [name, code, group]
            .filter { !$0.isEmpty }
            .joined(separator: " : ")
    }
    
    var subtitle: String {
        guard revenueExVAT > 0, productionQty > 0 else {
            return "No Sales or/and Production"
        }

        return "Sales \(salesQty.formattedGrouped) of \(productionQty.formattedGrouped) production\nx\(avgPriceExVAT.formattedGrouped) = \(revenueExVAT.formattedGrouped) ex VAT"
    }
    
    var detail: String? {
        guard isValid else { return errorMessage! }
        return note
    }
    
    static var color: Color { .systemPurple }
    static var icon: String { "bag.circle" }
    static var headline: String { "Create base product with ingredients." }
}

extension Buyer: Summarizable {
    var subtitle: String { "TBD: объем выручки по покупателю\nTBD: списк покупаемых продуктов" }
    
    static var color: Color { .systemPurple }
    static var icon: String { "cart.fill" }
    static var plusButtonIcon: String { "cart.badge.plus" }
}

extension Division: Summarizable {
    var title: String {
        guard headcount > 0 else { return "ERROR no people in Division" }
        
        return [name, headcount.formattedGrouped]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
    
    var subtitle: String {
        "Salary incl taxes \(salaryWithTax.formattedGrouped)"
    }
    
    var detail: String? {
        guard isValid else { return errorMessage! }
        return departmentNames
    }
    
    static var color: Color { .systemTeal }
    static var icon: String { "person.crop.rectangle" }
    static var plusButtonIcon: String { "rectangle.badge.plus" }
}

extension Department: Summarizable {
    var title: String {
        guard headcount > 0 else { return "ERROR no people in Department" }
        
        return [name, headcount.formattedGrouped].filter { !$0.isEmpty }.joined(separator: ", ")
    }
    
    var subtitle: String { "Salary incl taxes \(salaryWithTax.formattedGrouped)" }
    
    var detail: String? {
        guard isValid else { return errorMessage! }
        return "\(type.rawValue.capitalized)"
    }
    
    static var color: Color { .systemTeal }
    static var icon: String { "person.2" }
}

extension Employee: Summarizable {
    var subtitle: String {
        guard isValid else { return errorMessage! }
        
        return [position, department?.name ?? ""]
            .filter { !$0.isEmpty}
            .joined(separator: ": ")
    }
    
    var detail: String? {
        guard isValid else { return errorMessage! }
        return "\(salaryWithTax.formattedGrouped) (\(salary.formattedGrouped))"
    }
    
    static var color: Color { .systemTeal }
    static var icon: String { "person" }
    static var plusButtonIcon: String { "person.badge.plus" }
}

extension EmployeeDraft: Summarizable {
    var title: String { "\(name)" }
    var subtitle: String { "\(position) \(salary.formattedGrouped)" }
    var detail: String? { nil }
    
    static var icon: String { "person" }
    static var headline: String { "" }
}

extension Equipment: Summarizable {
    var subtitle: String { note }
    
    var detail: String? {
        guard isValid else { return errorMessage! }
        return "\(depreciationMonthly.formattedGrouped) per month for \(lifetime) years = \(price.formattedGrouped)"
    }
    
    static var color: Color { .systemIndigo }
    static var icon: String { "wrench.and.screwdriver" }
    static var plusButtonIcon: String { "plus.rectangle.on.rectangle" }
}

extension Expenses: Summarizable {
    var subtitle: String { amount.formattedGrouped }
    
    var detail: String? {
        guard isValid else { return errorMessage! }
        return note
    }
    
    static var color: Color { .systemTeal }
    static var icon: String { "dollarsign.circle" }
    static var plusButtonIcon: String { "text.badge.plus" }
}

extension Factory: Summarizable {
    
    var subtitle: String {
        guard revenueExVAT > 0 else {
            return "No Sales or/and Production"
        }
        
        return """
Sales / Production, t: \(salesWeightNetto.formattedGroupedWith1Decimal) / \(productionWeightNetto.formattedGroupedWith1Decimal)
Work Hours: \(productionWorkHours.formattedGrouped) (\(workHours.formattedGrouped))
Revenue: \(revenueExVAT.formattedGrouped)
        
\nTBD: Base products with production volume (in their units): Сулугуни (10,000), Хинкали(15,000)
"""
    }

    var detail: String? {
        guard isValid else { return errorMessage! }
        return note
    }
    
    static var icon: String { "building.2" }
}

extension Ingredient: Summarizable {
    
    var subtitle: String {
        guard let unitString_ = unitString_ else { return "" }
        
        return "Price \(priceExVAT.formattedGrouped)/\(unitString_), VAT \(vat.formattedPercentage)"
    }
    
    static var color: Color { .systemPurple }
    static var icon: String { "puzzlepiece" }
}

extension Recipe: Summarizable {
    var title: String { ingredient?.name ?? "ERROR: ingredient unknown" }
    
    var subtitle: String {
        qty.formattedGrouped + " " + customUnitString + " @ "
            + (ingredient == nil ? 0: ingredient!.priceExVAT).formattedGrouped
            + " = " + ingredientsExVAT.formattedGrouped
    }
    
    static var color: Color { .systemPurple }
    static var icon: String { "puzzlepiece" }
    static var plusButtonIcon: String { "plus.rectangle.on.rectangle" }
}

extension Packaging: Summarizable {
    var subtitle: String { type }
    
    var detail: String? {
        guard isValid else { return errorMessage! }
        return productList
    }
    
    static var color: Color { .systemIndigo }
    static var icon: String { "shippingbox" }
}

extension Product: Summarizable {
    var summary: String {
        "\(name)/\(code)/\(group)/\(note)"
    }
    var title: String {
        //        [baseName, name]
        //            .filter { !$0.isEmpty }
        //            .joined(separator: ", ")
        base == nil
            ? "\(name)"
            : "\(name) \(baseName), \(baseQty.formattedGrouped) \(customUnitString)"
    }
    
    var subtitle: String {
        guard revenueExVAT > 0, productionQty > 0 else {
            return "No Sales or/and Production"
        }
        
        return "Sales \(salesQty.formattedGrouped) of \(productionQty.formattedGrouped) production\nx\(avgPriceExVAT.formattedGrouped) = \(revenueExVAT.formattedGrouped) ex VAT"
    }

    static var icon: String { "bag" }
    static var plusButtonIcon: String { "bag.badge.plus" }
    static var headline: String {
        "Create a product for sale with base product, base product quantity, packaging, VAT and other parameters."
    }
}

extension RecipeDraft: Summarizable {
    var title: String { ingredient.name }
    
    var subtitle: String {
        //  MARK: - FINISH THIS
        //  как вытащить unitString в CustomUnit
        "\(qty.formattedGrouped) @ \(ingredient.priceExVAT.formattedGrouped)"
    }
    var detail: String? { nil }
    
    static var color: Color { .systemPurple }
    static var icon: String { "puzzlepiece" }
    static var headline: String { "" }
}

extension Sales: Summarizable {
    var title: String {
        buyer?.name ?? "ERROR no Buyer"
    }
    
    var subtitle: String {
        guard buyer != nil else { return "ERROR no Buyer" }
        guard qty > 0 else { return "ERROR qty" }
        guard priceExVAT > 0 else { return "ERROR price" }
        
        return "\(productName)\n\(qty.formattedGrouped) @ \(priceExVAT.formattedGrouped) = \(revenueExVAT.formattedGrouped)"
    }
    
    static var color: Color { .systemGreen }
    static var icon: String { "creditcard.fill" }
    static var plusButtonIcon: String { "rectangle.badge.plus" }
}

extension SalesDraft: Summarizable {
    var title: String {
        product?.name ?? buyer?.name ?? "ERROR no Product no Buyer"
    }
    
    var subtitle: String {
        "\(qty.formattedGrouped) @ \(priceExVAT.formattedGrouped)"
    }
    
    var detail: String? { nil }
    
    static var headline: String { "" }
    static var color: Color { .systemGreen }
    static var icon: String { "creditcard.fill" }
    static var plusButtonIcon: String { "rectangle.badge.plus" }
}

extension Utility: Summarizable {
    var subtitle: String {
        priceExVAT.formattedGroupedWithMax2Decimals
    }
    
    var detail: String? {
        guard isValid else { return errorMessage! }
        return vat.formattedPercentage
    }
    
    static var icon: String { "lightbulb" }
}
