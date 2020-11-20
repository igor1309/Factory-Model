//
//  Ingredientable.swift
//  Factory Model
//
//  Created by Igor Malyarov on 16.09.2020.
//

import Foundation

protocol Ingredientable {
    
    //  MARK: having Ingredients
    
    // func ingredientsExVAT(in period: Period) -> CostStructure
    
    func ingredientsExVAT(in period: Period) -> Double
}

extension Base: Ingredientable {
    func ingredientsExVAT(in period: Period) ->  Double {
        recipes.reduce(0) { $0 + $1.ingredientsExVAT }
    }
}

extension Product: Ingredientable {
    func ingredientsExVAT(in period: Period) -> Double {
        (base?.ingredientsExVAT(in: period) ?? 0) * baseQtyInBaseUnit
    }
}
