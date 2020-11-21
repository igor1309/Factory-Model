//
//  CostComponent.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.09.2020.
//

import SwiftUI

struct CostComponent: Identifiable {
    
    let id = UUID()
    
    /// Cost Component Name
    let title: String
    /// Cost Component Value
    let value: Double
    /// Cost Percentage: Cost Value to Full Cost
    let percentage: Double
    /// Cost Color
    let color: Color
    
    let fullCost: Double
    let formatWithDecimal: Bool
    
    init(
        title: String,
        value: Double,
        color: Color,
        fullCost: Double,
        formatWithDecimal: Bool
    ) {
        self.title = title
        self.value = value
        self.color = color
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
            title: title,
            value: value * number,
            color: color,
            fullCost: fullCost * number,
            formatWithDecimal: formatWithDecimal
        )
    }
    
    static func zero(title: String, color: Color) -> CostComponent {
        CostComponent(
            title: title,
            value: 0,
            color: color,
            fullCost: 0,
            formatWithDecimal: true
        )
    }
    
    static func + (_ lhs: CostComponent, _ rhs: CostComponent) -> CostComponent {
        CostComponent(
            title: lhs.title,
            value: lhs.value + rhs.value,
            color: lhs.color,
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
            title: lhs.title,
            value: lhs.value / rhs,
            color: lhs.color,
            fullCost: lhs.fullCost / rhs,
            formatWithDecimal: lhs.formatWithDecimal
        )
    }
}


extension CostComponent {
    
    private static var sample = (22.0, 18.0, 5.0, 3.0)
    private static var sampleTotal = sample.0 + sample.1 + sample.2 + sample.3
    
    static var ingredient: CostComponent {
        CostComponent(
            title: "Ingredient",
            value: sample.0,
            color: Ingredient.color,
            fullCost: sampleTotal,
            formatWithDecimal: false
        )
    }
    static var salary: CostComponent {
        CostComponent(
            title: "Salary",
            value: sample.1,
            color: Employee.color,
            fullCost: sampleTotal,
            formatWithDecimal: false
        )
    }
    static var depreciation: CostComponent {
        CostComponent(
            title: "Depreciation",
            value: sample.2,
            color: Equipment.color,
            fullCost: sampleTotal,
            formatWithDecimal: false
        )
    }
    static var utility: CostComponent {
        CostComponent(
            title: "Utility",
            value: sample.3,
            color: Utility.color,
            fullCost: sampleTotal,
            formatWithDecimal: false
        )
    }
}
