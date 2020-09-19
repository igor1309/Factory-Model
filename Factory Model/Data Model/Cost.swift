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
    
    let ingredientCostExVAT: Double
    /// Production Salary
    let salaryWithTax: Double
    let depreciation: Double
    let utilityCostExVAT: Double
    
    var costExVAT: Double {
        ingredientCostExVAT
            + salaryWithTax
            + depreciation
            + utilityCostExVAT
    }
    
    //  MARK: - formatted strings
    
    var costExVATStr: String {
        if hasDecimal {
            return costExVAT.formattedGroupedWith1Decimal
        } else {
            return costExVAT.formattedGrouped
        }
    }
    var ingredientCostExVATStr: String {
        if hasDecimal {
            return ingredientCostExVAT.formattedGroupedWith1Decimal
        } else {
            return ingredientCostExVAT.formattedGrouped
        }
    }
    var salaryWithTaxStr: String {
        if hasDecimal {
            return salaryWithTax.formattedGroupedWith1Decimal
        } else {
            return salaryWithTax.formattedGrouped
        }
    }
    var depreciationStr: String {
        if hasDecimal {
            return depreciation.formattedGroupedWith1Decimal
        } else {
            return depreciation.formattedGrouped
        }
    }
    var utilityCostExVATStr: String {
        if hasDecimal {
            return utilityCostExVAT.formattedGroupedWith1Decimal
        } else {
            return utilityCostExVAT.formattedGrouped
        }
    }
    
    
    //  MARK: - Percentage - %% of costExVATStr
    
    var ingredientCostExVATPercentage: Double {
        costExVAT == 0 ? 0 : ingredientCostExVAT / costExVAT
    }
    var salaryWithTaxPercentage: Double {
        costExVAT == 0 ? 0 : salaryWithTax / costExVAT
    }
    var depreciationPercentage: Double {
        costExVAT == 0 ? 0 : depreciation / costExVAT
    }
    var utilityCostExVATPercentage: Double {
        costExVAT == 0 ? 0 : utilityCostExVAT / costExVAT
    }
    
    
    //  MARK: - PercentageStr - %% of costExVATStr
    
    var ingredientCostExVATPercentageStr: String {
        if hasDecimal {
            return costExVAT == 0 ? "" : ingredientCostExVATPercentage.formattedPercentageWith1Decimal
        } else {
            return costExVAT == 0 ? "" : ingredientCostExVATPercentage.formattedPercentage
        }
    }
    var salaryWithTaxPercentageStr: String {
        if hasDecimal {
            return costExVAT == 0 ? "" : salaryWithTaxPercentage.formattedPercentageWith1Decimal
        } else {
            return costExVAT == 0 ? "" : salaryWithTaxPercentage.formattedPercentage
        }
    }
    var depreciationPercentageStr: String {
        if hasDecimal {
            return costExVAT == 0 ? "" : depreciationPercentage.formattedPercentageWith1Decimal
        } else {
            return costExVAT == 0 ? "" : depreciationPercentage.formattedPercentage
        }
    }
    var utilityCostExVATPercentageStr: String {
        if hasDecimal {
            return costExVAT == 0 ? "" : utilityCostExVATPercentage.formattedPercentageWith1Decimal
        } else {
            return costExVAT == 0 ? "" : utilityCostExVATPercentage.formattedPercentage
        }
    }
    
    
    //  MARK: - Chart Data
    
    var chartData: [ColorPercentage] {
        [
            ColorPercentage(Ingredient.color, ingredientCostExVATPercentage),
            ColorPercentage(Employee.color,   salaryWithTaxPercentage),
            ColorPercentage(Equipment.color,  depreciationPercentage),
            ColorPercentage(Utility.color,    utilityCostExVATPercentage)
        ]
    }
}
