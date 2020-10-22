//
//  CostComponent.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.09.2020.
//

import Foundation

struct CostComponent {
    
    /// Cost Value
    let value: Double
    /// Cost Percentage: Cost Value to Full Cost
    let percentage: Double
    
    let fullCost: Double
    let formatWithDecimal: Bool
    
    init(
        value: Double,
        fullCost: Double,
        formatWithDecimal: Bool
    ) {
        self.value = value
        self.fullCost = fullCost
        self.percentage = fullCost == 0 ? 0 : value / fullCost
        self.formatWithDecimal = formatWithDecimal
    }
    
    
    //  MARK: Formatted Strings
    
    /// Formatted String: Value
    var valueStr: String {
        if formatWithDecimal {
            return value.formattedGroupedWith1Decimal
        } else {
            return value.formattedGrouped
        }
    }
    /// Formatted String: Percentage
    var percentageStr: String {
        if formatWithDecimal {
            return percentage.formattedPercentageWith1Decimal
        } else {
            return percentage.formattedPercentage
        }
    }
    
}

extension CostComponent {
    
    func multiplying(by number: Double, formatWithDecimal: Bool) -> CostComponent {
        CostComponent(
            value: self.value * number,
            fullCost: self.fullCost * number,
            formatWithDecimal: formatWithDecimal
        )
    }
    
    static let zero = CostComponent(
        value: 0,
        fullCost: 0,
        formatWithDecimal: true
    )
    
    static func + (_ lhs: CostComponent, _ rhs: CostComponent) -> CostComponent {
        CostComponent(
            value: lhs.value + rhs.value,
            fullCost: lhs.fullCost + rhs.fullCost,
            formatWithDecimal: lhs.formatWithDecimal
        )
    }
//    static func * (_ lhs: Double, _ rhs: CostComponent) -> CostComponent {
//        CostComponent(
//            value: lhs * rhs.value,
//            fullCost: lhs * rhs.fullCost,
//            formatWithDecimal: rhs.formatWithDecimal
//        )
//    }
    static func / (_ lhs: CostComponent, _ rhs: Double) -> CostComponent {
        CostComponent(
            value: lhs.value / rhs,
            fullCost: lhs.fullCost / rhs,
            formatWithDecimal: lhs.formatWithDecimal
        )
    }
}

