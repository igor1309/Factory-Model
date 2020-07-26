//
//  Summarable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

protocol Summarable {
    var title: String { get }
    var subtitle: String { get }
    var detail: String? { get }
    var icon: String { get }
}

extension Department: Summarable {
    var title: String {
        name
    }
    var subtitle: String {
        division
    }
    var detail: String? {
        type.rawValue
    }
    var icon: String {
        "person.2.circle"
    }
}

extension Factory: Summarable {
    var title: String {
        name
    }
    var subtitle: String {
        note
    }
    var detail: String? {
        "TBD: Base products with production volume (in their units): Сулугуни (10,000), Хинкали(15,000)"
    }
    var icon: String {
        "building.2"
    }
}

extension Equipment: Summarable {
    var title: String { name }
    var subtitle: String { note }
    
    var detail: String? {
        "\(depreciationMonthly.formattedGrouped) per month for \(lifetime) years = \(price.formattedGrouped)"
    }
    
    var icon: String { "wrench.and.screwdriver" }
}

extension Expenses: Summarable {
    var title: String { name }
    var subtitle: String { amount.formattedGrouped }
    var detail: String? { note }
    var icon: String { "dollarsign.circle" }
}

extension Feedstock: Summarable {
    var title: String { name }
    
    var subtitle: String {
        "\(qty.formattedGrouped) @ \(priceExVAT) = \(costExVAT.formattedGrouped)"
    }
    
    var detail: String? { nil }
    var icon: String { "puzzlepiece" }
}

extension Packaging: Summarable {
    var title: String {
        name
    }
    
    var subtitle: String {
        type
    }
    
    var detail: String? {
        if products_ == nil || products.isEmpty {
            return "ERROR: not used in products"
        }
        return products.map { $0.title }.joined(separator: ", ")
    }
    
    var icon: String {
        "shippingbox"
    }
}

extension Product: Summarable {
    var summary: String {
        "\(name)/\(code)/\(group)/\(note)"
    }
    var title: String {
//        [baseName, name]
//            .filter { !$0.isEmpty }
//            .joined(separator: ", ")
        base == nil
            ? "\(name)"
            : "\(name) \(baseName), \(baseQty.formattedGrouped) \(base!.unit.idd), \(weightNetto.formattedGrouped)г"
    }
    
    var subtitle: String {
        base == nil
            ? "ERROR: no base for product"
            : [name, group, code]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
    
    var detail: String? {
        if base == nil {
            return "ERROR: no base for product"
        }
        if productionQty == 0 {
            return "ERROR: no production for product"
        }
        if sales.isEmpty {
            return "ERROR: no sales for product"
        }
        return [name, group, code]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
    
    var icon: String { "bag.circle" }
}

extension Base: Summarable {
    var title: String {
        [name, code, group]
            .filter { !$0.isEmpty }
            .joined(separator: " : ")
    }
    
    var subtitle: String { note }
    
    var detail: String? {
        if closingInventory < 0 {
            return "ERROR: Negative Closing Inventory"
        }
        
        if revenueExVAT > 0 {
            return "\(totalSalesQty.formattedGrouped) of \(productionQty.formattedGrouped) @ \(avgPriceExVAT) = \(revenueExVAT.formattedGrouped)"
        } else {
            return "Baseion \(productionQty.formattedGrouped)"
        }
    }
    
    var icon: String { "bag" }
}

extension Sales: Summarable {
    var title: String { buyer }
    
    var subtitle: String {
        "\(productName): \(qty.formattedGrouped) @ \(priceExVAT.formattedGrouped) = \(revenueExVAT.formattedGrouped)"
    }
    
    var detail: String? { nil }
    var icon: String { "creditcard.fill" }
}

extension Staff: Summarable {
    var title: String { name }
    var subtitle: String { salary.formattedGrouped }
    
    var detail: String? {
        [department?.name ?? "", position]
            .filter { !$0.isEmpty}
            .joined(separator: ": ")
    }
    
    var icon: String { "person" }
}

extension Utility: Summarable {
    var title: String { name }
    var subtitle: String { priceExVAT.formattedGroupedWithMax2Decimals }
    var detail: String? { vat.formattedPercentage }
    var icon: String { "lightbulb" }
}
