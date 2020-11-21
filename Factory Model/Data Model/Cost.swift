//
//  Cost.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import SwiftUI

struct Cost {
    
    init(
        title: String,
        header: String,
        components: [CostComponent],
        formatWithDecimal: Bool = false
    ) {
        self.title = title
        self.header = header
        self.formatWithDecimal = formatWithDecimal
        self.components = components
    }
    
    let title: String
    let header: String
    
    let formatWithDecimal: Bool
    
    let components: [CostComponent]
    
    /// Full Cost
    var fullCost: Double {
        components.reduce(0, { $0 + $1.value})
    }
    
    //  MARK: Formatted Strings
    
    /// Full Cost Formatted String
    var fullCostStr: String {
        if formatWithDecimal {
            return fullCost.formattedGroupedWith1Decimal
        } else {
            return fullCost.formattedGrouped
        }
    }
    
    
    //  MARK: Chart Data
    
    var chartData: [ColorPercentage] {
        components.map {
            ColorPercentage($0.color, $0.percentage)
        }
    }
}

extension Cost {
    
    func multiplying(by number: Double, formatWithDecimal: Bool) -> Cost {
        Cost(
            title: self.title,
            header: self.header,
            components: components.map {
                $0.multiplying(by: number, formatWithDecimal: formatWithDecimal)
            },
            formatWithDecimal: formatWithDecimal
        )
    }
    
    static func + (_ lhs: Cost, _ rhs: Cost) -> Cost {
        Cost(
            title: lhs.title,
            header: lhs.header,
            components: zip(lhs.components, rhs.components).map(+),
            formatWithDecimal: lhs.formatWithDecimal
        )
    }
//    static func * (_ lhs: Double, _ rhs: Cost) -> Cost {
//        Cost(
//            title: rhs.title,
//            header: rhs.header,
//            ingredient: lhs * rhs.ingredient,
//            salary: lhs * rhs.salary,
//            depreciation: lhs * rhs.depreciation,
//            utility: lhs * rhs.utility,
//            formatWithDecimal: rhs.formatWithDecimal
//        )
//    }
    static func / (_ lhs: Cost, _ rhs: Double) -> Cost {
        Cost(
            title: lhs.title,
            header: lhs.header,
            components: lhs.components.map { $0 / rhs },
            formatWithDecimal: lhs.formatWithDecimal
        )
    }
}

extension Cost {
    static var example: Cost {
        Cost(
            title: "Test Cost",
            header: "Production Cost Structure",
            components: [
                CostComponent.ingredient,
                CostComponent.salary,
                CostComponent.depreciation,
                CostComponent.utility
            ]
        )
    }
}
