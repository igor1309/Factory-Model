//
//  PriceCostMargin.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.09.2020.
//

import Foundation

struct PriceCostMargin {
    /// price/revenue/market value
    let price: Double
    /// cost
    let cost: Cost
    /// weight netto
    let weightNetto: Double
    
    /// format strings using decimal
    var formatWithDecimal: Bool = false
    
    /// for sold items
    var revenue: Double { price }
    /// for produced items
    var marketValue: Double { price }
    
    var margin: Double {
        price - cost.fullCost
    }
    var marginPercentage: Double {
        price == 0 ? 0 : margin / price
    }
    
    /// Weight Netto in Tons
    var weightNettoTons: Double {
        weightNetto / 1_000_000
    }
    
    
    //  MARK: Formatted Strings
    
    var priceStr: String {
        if formatWithDecimal {
            return price.formattedGroupedWith1Decimal
        } else {
            return price.formattedGrouped
        }
    }
    var revenueStr: String { priceStr }
    var marketValueStr: String { priceStr }
    
    var weightNettoStr: String {
        weightNetto.formattedGrouped
    }
    var weightNettoTonsStr: String {
        weightNettoTons.formattedGroupedWith1Decimal
    }
    var marginStr: String {
        if formatWithDecimal {
            return margin.formattedGroupedWith1Decimal
        } else {
            return margin.formattedGrouped
        }
    }
    var marginPercentageStr: String {
        marginPercentage.formattedPercentageWith1Decimal
    }
}

extension PriceCostMargin {
    
    func updatingCost(title: String, header: String) -> PriceCostMargin {
        let cost = Cost(
            title: title,
            header: header,
            components: self.cost.components,
            formatWithDecimal: self.cost.formatWithDecimal
        )
        
        return PriceCostMargin(
            price: price,
            cost: cost,
            weightNetto: weightNetto,
            formatWithDecimal: formatWithDecimal
        )
    }
    
    func multiplying(by number: Double, formatWithDecimal: Bool) -> PriceCostMargin {
        PriceCostMargin(
            price: self.price * number,
            cost: self.cost.multiplying(by: number, formatWithDecimal: formatWithDecimal),
            weightNetto: self.weightNetto * number,
            formatWithDecimal: formatWithDecimal
        )
    }
    
    static func productionZero(title: String, header: String) -> PriceCostMargin {
        let components = [
            CostComponent.zero(title: "Ingredient", color: Ingredient.color),
            CostComponent.zero(title: "Salary", color: Employee.color),
            CostComponent.zero(title: "Depreciation", color: Equipment.color),
            CostComponent.zero(title: "Utility", color: Utility.color)
        ]
        
        return PriceCostMargin(
            price: 0,
            cost: Cost(title: title, header: header, components: components),
            weightNetto: 0,
            formatWithDecimal: true
        )
    }
    
    static var example: PriceCostMargin {
        PriceCostMargin(
            price: 12345,
            cost: Cost(
                title: "Example PCM",
                header: "PriceCostMargin",
                components: [
                    CostComponent.zero(title: "Ingredient", color: Ingredient.color),
                    CostComponent.zero(title: "Salary", color: Employee.color),
                    CostComponent.zero(title: "Depreciation", color: Equipment.color),
                    CostComponent.zero(title: "Utility", color: Utility.color)
                ]
            ),
            weightNetto: 0,
            formatWithDecimal: true
        )
    }
    
    static func + (_ lhs: PriceCostMargin, _ rhs: PriceCostMargin) -> PriceCostMargin {
        PriceCostMargin(
            price: lhs.price + rhs.price,
            cost: lhs.cost + rhs.cost,
            weightNetto: lhs.weightNetto + rhs.weightNetto,
            formatWithDecimal: lhs.formatWithDecimal
        )
    }
    //    static func * (_ lhs: Double, _ rhs: PriceCostMargin) -> PriceCostMargin {
    //        PriceCostMargin(
    //            price: lhs * rhs.price,
    //            cost: lhs * rhs.cost,
    //            weightNetto: lhs * rhs.weightNetto,
    //            formatWithDecimal: rhs.formatWithDecimal
    //        )
    //    }
    static func / (_ lhs: PriceCostMargin, _ rhs: Double) -> PriceCostMargin {
        PriceCostMargin(
            price: lhs.price / rhs,
            cost: lhs.cost / rhs,
            weightNetto: lhs.weightNetto / rhs,
            formatWithDecimal: lhs.formatWithDecimal
        )
    }
}

