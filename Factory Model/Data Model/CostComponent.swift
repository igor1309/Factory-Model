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
    
    private let hasDecimal: Bool
    
    init(value: Double, fullCost: Double, hasDecimal: Bool) {
        self.value = value
        self.percentage = fullCost == 0 ? 0 : value / fullCost
        self.hasDecimal = hasDecimal
    }
    
    
    //  MARK: Formatted Strings
    
    /// Formatted String: Value
    var valueStr: String {
        if hasDecimal {
            return value.formattedGroupedWith1Decimal
        } else {
            return value.formattedGrouped
        }
    }
    /// Formatted String: Percentage
    var percentageStr: String {
        if hasDecimal {
            return percentage.formattedGroupedWith1Decimal
        } else {
            return percentage.formattedGrouped
        }
    }
    
}
