//
//  Cost.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import SwiftUI

struct Cost {
    
    internal init(title: String, header: String, hasDecimal: Bool = false, ingredient: CostComponent, salary: CostComponent, depreciation: CostComponent, utility: CostComponent) {
        self.title = title
        self.header = header
        self.hasDecimal = hasDecimal
        self.ingredient = ingredient
        self.salary = salary
        self.depreciation = depreciation
        self.utility = utility
    }
    
    let title: String
    let header: String
    
    private var hasDecimal: Bool = false
    
    /// Ingredient Cost ex VAT
    let ingredient: CostComponent//Double
    /// Production Salary with Tax
    let salary: CostComponent//Double
    /// Depreciation
    let depreciation: CostComponent//Double
    /// Utility ex VAT
    let utility: CostComponent//Double
    
    /// Full Cost
    var fullCost: Double {
        ingredient.value
            + salary.value
            + depreciation.value
            + utility.value
    }
    
    //  MARK: Formatted Strings
    
    /// Full Cost Formatted String
    var fullCostStr: String {
        if hasDecimal {
            return fullCost.formattedGroupedWith1Decimal
        } else {
            return fullCost.formattedGrouped
        }
    }
    
    
    //  MARK: Chart Data
    
    var chartData: [ColorPercentage] {
        [
            ColorPercentage(Ingredient.color, ingredient.percentage),
            ColorPercentage(Employee.color, salary.percentage),
            ColorPercentage(Equipment.color, depreciation.percentage),
            ColorPercentage(Utility.color, utility.percentage)
        ]
    }
}
