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
        ingredient: CostComponent,
        salary: CostComponent,
        depreciation: CostComponent,
        utility: CostComponent,
        formatWithDecimal: Bool = false
    ) {
        self.title = title
        self.header = header
        self.formatWithDecimal = formatWithDecimal
        self.ingredient = ingredient
        self.salary = salary
        self.depreciation = depreciation
        self.utility = utility
    }
    
    let title: String
    let header: String
    
    let formatWithDecimal: Bool
    
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
        if formatWithDecimal {
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

extension Cost {
    
    func multiplying(by number: Double, formatWithDecimal: Bool) -> Cost {
        Cost(
            title: self.title,
            header: self.header,
            ingredient: self.ingredient.multiplying(by: number, formatWithDecimal: formatWithDecimal),
            salary: self.salary.multiplying(by: number, formatWithDecimal: formatWithDecimal),
            depreciation: self.depreciation.multiplying(by: number, formatWithDecimal: formatWithDecimal),
            utility: self.utility.multiplying(by: number, formatWithDecimal: formatWithDecimal),
            formatWithDecimal: formatWithDecimal
        )
    }
    
    static func + (_ lhs: Cost, _ rhs: Cost) -> Cost {
        Cost(
            title: lhs.title,
            header: lhs.header,
            ingredient: lhs.ingredient + rhs.ingredient,
            salary: lhs.salary + rhs.salary,
            depreciation: lhs.depreciation + rhs.depreciation,
            utility: lhs.utility + rhs.utility,
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
            ingredient: lhs.ingredient / rhs,
            salary: lhs.salary / rhs,
            depreciation: lhs.depreciation / rhs,
            utility: lhs.utility / rhs,
            formatWithDecimal: lhs.formatWithDecimal
        )
    }
}

extension Cost {
    static var example: Cost {
        Cost(
            title: "Test Cost",
            header: "Production Cost Structure",
            ingredient: CostComponent.ingredient,
            salary: CostComponent.salary,
            depreciation: CostComponent.depreciation,
            utility: CostComponent.utility
        )
    }
}
