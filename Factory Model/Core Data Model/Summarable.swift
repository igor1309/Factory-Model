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
        "\(qty.formattedGrouped) @ \(price) = \(cost.formattedGrouped)"
    }
    
    var detail: String? { nil }
    var icon: String { "puzzlepiece" }
}

extension Product: Summarable {
    var title: String {
        [name, code, group, packagingCode]
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
            return "Production \(productionQty.formattedGrouped)"
        }
    }
    
    var icon: String { "bag" }
}

extension Sales: Summarable {
    var title: String { buyer }
    
    var subtitle: String {
        "\(productName): \(qty.formattedGrouped) @ \(price.formattedGrouped) = \(total.formattedGrouped)"
    }
    
    var detail: String? { nil }
    var icon: String { "cart" }
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
    var subtitle: String { price.formattedGroupedWithMax2Decimals }
    var detail: String? { nil }
    var icon: String { "lightbulb" }
}
