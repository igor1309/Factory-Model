//
//  Summarable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import Foundation

protocol Summarable {
    var title: String { get }
    var subtitle: String { get }
    var detail: String? { get }
    var icon: String { get }
}

extension Equipment: Summarable {
    var title: String { name }
    var subtitle: String { note }
    
    var detail: String? {
        "\(amortizationMonthly.formattedGrouped) per month for \(lifetime) years = \(price.formattedGrouped)"
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
//        [baseName, name]
//            .filter { !$0.isEmpty }
//            .joined(separator: ", ")
        base == nil
            ? "\(name)"
            : "\(baseName), \(type) \(baseQty.formattedGrouped) \(base!.unit.idd)"
    }
    
    var subtitle: String {
        [code, note]
            .filter { !$0.isEmpty}
            .joined(separator: ": ")
    }
    
    var detail: String? {
        base == nil
            ? "ERROR: no base for packaging"
            : [name, type, code]
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
        "\(packagingName): \(qty.formattedGrouped) @ \(priceExVAT.formattedGrouped) = \(revenueExVAT.formattedGrouped)"
    }
    
    var detail: String? { nil }
    var icon: String { "creditcard.fill" }
}

extension Staff: Summarable {
    var title: String { name }
    var subtitle: String { salary.formattedGrouped }
    
    var detail: String? {
        [department, position]
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
