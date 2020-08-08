//
//  Recipe.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import Foundation

extension Recipe: Comparable {
    
    var parentUnit: CustomUnit? { ingredient?.customUnit }
    
    var customUnit: CustomUnit? {
        get {
            if let ingredientUnit = parentUnit {
                let customUnit = CustomUnit.unit(from: ingredientUnit, with: coefficientToParentUnit)
                return customUnit
            } else {
                return nil
            }
        }
        set {
            if let ingredientUnit = parentUnit,
               let newValue = newValue,
               let coefficient = newValue.coefficient(to: ingredientUnit) {
                coefficientToParentUnit = coefficient
            }
        }
    }
    var customUnitString: String { customUnit?.rawValue ?? "??" }
    
    var ingredientQtyInIngredientUnit: Double {
        qty * coefficientToParentUnit
    }
    
    var ingredientPriceExVAT: Double {
        ingredient?.priceExVAT ?? 0
    }
    
    var cost: Double {
        qty * coefficientToParentUnit * ingredientPriceExVAT
    }
    
    public static func < (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.qty < rhs.qty
    }
}
