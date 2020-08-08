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

    var productionQty: Double {
        recipes
            .reduce(0) { $0 + $1.ingredientQtyInIngredientUnit * ($1.base?.productionQty ?? 0) }
    }

    var totalCostExVat:   Double { priceExVAT   * productionQty }
    var totalCostWithVat: Double { priceWithVAT * productionQty }
}

extension Ingredient: Comparable {
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.name < rhs.name
    }
}
