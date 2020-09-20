//
//  Cost.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import SwiftUI

struct Cost {
    
    let title: String
    let header: String
    
    var hasDecimal: Bool = false
    
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
    
    //  MARK: - formatted strings
    
    /// Full Cost Formatted String
    var fullCostStr: String {
        if hasDecimal {
            return fullCost.formattedGroupedWith1Decimal
        } else {
            return fullCost.formattedGrouped
        }
    }
//    var ingredientStr: String {
//        if hasDecimal {
//            return ingredient.formattedGroupedWith1Decimal
//        } else {
//            return ingredient.formattedGrouped
//        }
//    }
//    var salaryStr: String {
//        if hasDecimal {
//            return salary.formattedGroupedWith1Decimal
//        } else {
//            return salary.formattedGrouped
//        }
//    }
//    var depreciationStr: String {
//        if hasDecimal {
//            return depreciation.formattedGroupedWith1Decimal
//        } else {
//            return depreciation.formattedGrouped
//        }
//    }
//    var utilityStr: String {
//        if hasDecimal {
//            return utility.formattedGroupedWith1Decimal
//        } else {
//            return utility.formattedGrouped
//        }
//    }
    
    
//    //  MARK: - Percentage - %% of costExVATStr
//
//    /// Ingredient Percentage: Ingredient to Full Cost
//    var ingredientPercentage: Double {
//        fullCost == 0 ? 0 : ingredient / fullCost
//    }
//    /// Salary Percentage: Salary to Full Cost
//    var salaryPercentage: Double {
//        fullCost == 0 ? 0 : salary / fullCost
//    }
//    /// Depreciation Percentage: Depreciation to Full Cost
//    var depreciationPercentage: Double {
//        fullCost == 0 ? 0 : depreciation / fullCost
//    }
//    /// Utility Percentage: Utility to Full Cost
//    var utilityPercentage: Double {
//        fullCost == 0 ? 0 : utility / fullCost
//    }
    
    
//    //  MARK: - PercentageStr - Formatted String: Percentage of fullCost
//
//    var ingredientPercentageStr: String {
//        if hasDecimal {
//            return fullCost == 0 ? "" : ingredientPercentage.formattedPercentageWith1Decimal
//        } else {
//            return fullCost == 0 ? "" : ingredientPercentage.formattedPercentage
//        }
//    }
//    var salaryPercentageStr: String {
//        if hasDecimal {
//            return fullCost == 0 ? "" : salaryPercentage.formattedPercentageWith1Decimal
//        } else {
//            return fullCost == 0 ? "" : salaryPercentage.formattedPercentage
//        }
//    }
//    var depreciationPercentageStr: String {
//        if hasDecimal {
//            return fullCost == 0 ? "" : depreciationPercentage.formattedPercentageWith1Decimal
//        } else {
//            return fullCost == 0 ? "" : depreciationPercentage.formattedPercentage
//        }
//    }
//    var utilityPercentageStr: String {
//        if hasDecimal {
//            return fullCost == 0 ? "" : utilityPercentage.formattedPercentageWith1Decimal
//        } else {
//            return fullCost == 0 ? "" : utilityPercentage.formattedPercentage
//        }
//    }
    
    
    //  MARK: - Chart Data
    
    var chartData: [ColorPercentage] {
        [
            ColorPercentage(Ingredient.color, ingredient.percentage),
            ColorPercentage(Employee.color, salary.percentage),
            ColorPercentage(Equipment.color, depreciation.percentage),
            ColorPercentage(Utility.color, utility.percentage)
        ]
    }
}
