//
//  Ingredient.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation
import CoreData

extension Ingredient {
    var customUnit: CustomUnit? {
        get { CustomUnit(rawValue: unitString_ ?? "") }
        set { unitString_ = newValue?.rawValue }
    }
    
    var priceWithVAT: Double {
        get { priceExVAT * (1 + vat) }
        set { priceExVAT = vat == 0 ? 0 : newValue / vat }
    }
    var recipes: [Recipe] {
        get { (recipes_ as? Set<Recipe> ?? []).sorted() }
        set { recipes_ = Set(newValue) as NSSet }
    }

    func cost(in period: Period) -> Double {
        priceExVAT * productionQty(in: period)
    }
        
    /// if Factory is nill sum production Qty for all factories
    func productionQty(for factory: Factory? = nil, in period: Period) -> Double {
        recipes
            .filter {
                if let factory = factory {
                    return $0.base?.factory == factory
                } else {
                    return true
                }
            }
            .reduce(0) { $0 + $1.productionQty(in: period) }
    }

    func totalCostExVat(for factory: Factory? = nil, in period: Period) -> Double {
        priceExVAT * productionQty(for: factory, in: period)
    }
    func totalCostWithVat(for factory: Factory? = nil, in period: Period) -> Double {
        priceWithVAT * productionQty(for: factory, in: period)
    }
}

extension Ingredient: Comparable {
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.name < rhs.name
    }
}
