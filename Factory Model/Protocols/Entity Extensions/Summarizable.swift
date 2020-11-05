//
//  Summarable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

protocol Summarizable {
    func title(in period: Period) -> String
    func subtitle(in period: Period) -> String
    func detail(in period: Period) -> String?
    
    static var color: Color { get }
    static var icon: String { get }
    static var plusButtonIcon: String { get }
    static var headline: String { get }
}
extension Summarizable where Self: Monikerable {
    func title(in period: Period) -> String {
        name.isEmpty ? "ERROR: no name" : name
    }
}
extension Summarizable {
    static var color: Color { .accentColor }
    static var plusButtonIcon: String { "plus" }
}
extension Summarizable where Self: Inventorable & Merch & Warable {
    func subtitle(in period: Period) -> String {
        guard sold(in: period).revenue > 0, productionQty(in: period) > 0 else {
            return "ERROR: No Sales or Production"
        }
        
        guard salesQty(in: period) <= productionQty(in: period) + initialInventory else {
            return "ERROR: Sold more than produced"
        }
        
        return """
Sales \(sold(in: period).weightNettoTonsStr) of \(produced(in: period).weightNettoTonsStr)t production
\(salesQty(in: period).formattedGrouped) of \(productionQty(in: period).formattedGrouped)
x\(unit(in: period).priceStr) = \(sold(in: period).revenueStr) ex VAT
"""
    }
}
extension Summarizable where Self: Validatable {
    func detail(in period: Period) -> String? { errorMessage }
}
extension Summarizable where Self: Managed {
    static var headline: String {
        "Create \(Self.entityName.lowercased())."
    }
}


extension Base: Summarizable {
    func title(in period: Period) -> String {
        [name, code, group]
            .filter { !$0.isEmpty }
            .joined(separator: " : ")
    }
    
    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        return note
    }
    
    static var color: Color { .systemPurple }
    static var icon: String { "bag.circle" }
    static var plusButtonIcon: String { "bag.badge.plus" }
    static var headline: String { "Create base product with ingredients." }
}

extension Buyer: Summarizable {
    func subtitle(in period: Period) -> String { "TBD: объем выручки по покупателю\nTBD: списк покупаемых продуктов" }
    
    static var color: Color { .systemPurple }
    static var icon: String { "cart.fill" }
    static var plusButtonIcon: String { "cart.badge.plus" }
}

extension Division: Summarizable {
    func title(in period: Period) -> String {
        guard headcount > 0 else { return "ERROR no people in Division" }
        
        return [name, headcount.formattedGrouped]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
    
    func subtitle(in period: Period) -> String {
        "Salary incl taxes \(salaryWithTax(in: period).formattedGrouped)"
    }
    
    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        return departmentNames
    }
    
    static var color: Color { .systemTeal }
    static var icon: String { "person.crop.rectangle" }
    static var plusButtonIcon: String { "rectangle.badge.plus" }
}

extension Department: Summarizable {
    func title(in period: Period) -> String {
        guard headcount > 0 else { return "ERROR no people in Department" }
        
        return [name, headcount.formattedGrouped].filter { !$0.isEmpty }.joined(separator: ", ")
    }
    
    func subtitle(in period: Period) -> String {
        "Salary incl taxes \(salaryWithTax(in: period).formattedGrouped)"
    }
    
    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        return "\(type.rawValue.capitalized)"
    }
    
    static var color: Color { .systemTeal }
    static var icon: String { "person.2" }
    static var plusButtonIcon: String { "rectangle.stack.badge.plus" }
}

extension Employee: Summarizable {
    func subtitle(in period: Period) -> String {
        guard isValid else { return errorMessage! }
        
        return [position, department?.name ?? ""]
            .filter { !$0.isEmpty}
            .joined(separator: ": ")
    }
    
    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        
        if self.period == period {
            return "\(salaryWithTax(in: period).formattedGrouped) (\(salaryExTax(in: period).formattedGrouped))"
        } else {
            return "\(salaryWithTax(in: period).formattedGrouped) (\(salaryExTax(in: period).formattedGrouped): \(salary.formattedGrouped) \(self.period.brief))"
        }
    }
    
    static var color: Color { .systemTeal }
    static var icon: String { "person" }
    static var plusButtonIcon: String { "person.badge.plus" }
}

extension EmployeeDraft: Summarizable {
    func title(in period: Period) -> String { "\(name)" }
    func subtitle(in period: Period) -> String { "\(position) \(salary.formattedGrouped)" }
    func detail(in period: Period) -> String? { nil }
    
    static var icon: String { "person" }
    static var headline: String { "" }
}

extension Equipment: Summarizable {
    func subtitle(in period: Period) -> String { note }
    
    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        return "\(depreciationMonthly.formattedGrouped) per month for \(lifetime) years = \(price.formattedGrouped)"
    }
    
    static var color: Color { .systemIndigo }
    static var icon: String { "wrench.and.screwdriver" }
    static var plusButtonIcon: String { "plus.rectangle.on.rectangle" }
}

extension Expenses: Summarizable {
    func subtitle(in period: Period) -> String {
        if self.period == period {
            return "\(amount(in: period).formattedGrouped)"
        } else {
            return "\(amount(in: period).formattedGrouped) (\(amount.formattedGrouped) \(self.period.brief))"
        }
    }
    
    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        return note
    }
    
    static var color: Color { .systemTeal }
    static var icon: String { "dollarsign.circle" }
    static var plusButtonIcon: String { "text.badge.plus" }
}

extension Factory: Summarizable {
    
    func subtitle(in period: Period) -> String {
        guard revenueExVAT(in: period) > 0 else {
            return "No Sales or/and Production"
        }
        
        return """
(\(period.short))

Production \(produced(in: period).weightNettoTonsStr) tons
Market Value \(produced(in: period).priceStr)
Cost \(produced(in: period).cost.fullCostStr)

Sales \(sold(in: period).weightNettoTonsStr) tons
\(sold(in: period).priceStr)

Margin \(sold(in: period).marginStr) (\(sold(in: period).marginPercentageStr))

Headcount \(headcount)

(??) Work Hours
- production \(productionWorkHours(in: period).formattedGrouped)
- total \(workHours(in: period).formattedGrouped)
        
TBD: Base product lists with production volume (in their units): Сулугуни (10,000), Хинкали(15,000)

Production per year \(produced(in: .year()).weightNettoTonsStr) tons
Equipment \(equipmentTotal.formattedGrouped)
"""
    }

    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        return note
    }
    
    static var icon: String { "building.2" }
}

extension Ingredient: Summarizable {
    
    func subtitle(in period: Period) -> String {
        guard let unitString_ = unitString_ else { return "" }
        
        return "Price \(priceExVAT.formattedGrouped)/\(unitString_), VAT \(vat.formattedPercentage)"
    }
    
    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        
        let totalCost = cost(in: period)
        if totalCost > 0 {
            return "Total Cost ex VAT \(totalCost.formattedGrouped) for \(productionQty(in: period).formattedGrouped) used in production"
        } else {
            return ""
        }
    }
    
    static var color: Color { .systemPurple }
    static var icon: String { "puzzlepiece" }
    static var plusButtonIcon: String { "square.grid.3x1.folder.badge.plus" }
}

extension Packaging: Summarizable {
    func subtitle(in period: Period) -> String { type }
    
    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        return "Products: \(productList(in: period))"
    }
    
    static var color: Color { .systemIndigo }
    static var icon: String { "shippingbox" }
    static var plusButtonIcon: String { "rectangle.badge.plus" }
}

extension Product: Summarizable {
    var summary: String {
        "\(name)/\(code)/\(group)/\(note)"
    }
    
    func title(in period: Period) -> String {
        //        [baseName, name]
        //            .filter { !$0.isEmpty }
        //            .joined(separator: ", ")
        base == nil
            ? "\(name)"
            : "\(name) \(baseName), \(baseQty.formattedGrouped) \(customUnitString)"
    }
    
    static var icon: String { "bag" }
    static var plusButtonIcon: String { "bag.badge.plus" }
    static var headline: String {
        "Create a product for sale with base product, base product quantity, packaging, VAT and other parameters."
    }
}

extension Recipe: Summarizable {
    func title(in period: Period) -> String { ingredient?.name ?? "ERROR: ingredient unknown" }
    
    func subtitle(in period: Period) -> String {
        qty.formattedGrouped + " " + customUnitString + " @ "
            + (ingredient?.priceExVAT ?? 0).formattedGrouped
            + " = " + ingredientsExVAT.formattedGrouped
    }
    
    static var color: Color { .systemPurple }
    static var icon: String { "link.circle" }   //"puzzlepiece" }
    static var plusButtonIcon: String { "link.badge.plus" }    //"plus.rectangle.on.rectangle" }
}

extension RecipeDraft: Summarizable {
    func title(in period: Period) -> String { ingredient.name }
    
    func subtitle(in period: Period) -> String {
        //  MARK: - FINISH THIS
        //  как вытащить unitString в CustomUnit
        "\(qty.formattedGrouped) @ \(ingredient.priceExVAT.formattedGrouped)"
    }
    
    func detail(in period: Period) -> String? { nil }
    
    static var color: Color { .systemPurple }
    static var icon: String { "puzzlepiece" }
    static var headline: String { "" }
}

extension Sales: Summarizable {
    func title(in period: Period) -> String {
        buyer?.name ?? "ERROR no Buyer"
    }
    
    func subtitle(in period: Period) -> String {
        guard isValid else { return errorMessage! }
        
        if self.period == period {
            return "\(productName)\n\(qty.formattedGrouped) @ \(priceExVAT.formattedGrouped) = \(revenueExVAT(in: period).formattedGrouped)"
        } else {
            return "\(productName)\n\(qty.formattedGrouped) @ \(priceExVAT.formattedGrouped) \(self.period.brief)\n= \(revenueExVAT(in: period).formattedGrouped) \(period.brief)"
        }
    }
    
    static var color: Color { .systemGreen }
    static var icon: String { "creditcard.fill" }
    static var plusButtonIcon: String { "cart.badge.plus" }
}

extension SalesDraft: Summarizable {
    func title(in period: Period) -> String {
        product?.name ?? buyer?.name ?? "ERROR no Product no Buyer"
    }
    
    func subtitle(in period: Period) -> String {
        "\(qty.formattedGrouped) @ \(priceExVAT.formattedGrouped)"
    }
    
    func detail(in period: Period) -> String? { nil }
    
    static var headline: String { "" }
    static var color: Color { .systemGreen }
    static var icon: String { "creditcard.fill" }
    static var plusButtonIcon: String { "rectangle.badge.plus" }
}

extension Utility: Summarizable {
    func subtitle(in period: Period) -> String {
        priceExVAT.formattedGroupedWithMax2Decimals
    }
    
    func detail(in period: Period) -> String? {
        guard isValid else { return errorMessage! }
        return vat.formattedPercentage
    }
    
    static var icon: String { "lightbulb" }
    static var plusButtonIcon: String { "gauge.badge.plus" }
}
