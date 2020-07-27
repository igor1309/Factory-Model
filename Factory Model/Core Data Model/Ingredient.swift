//
//  Ingredient.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import Foundation

extension Ingredient: Comparable {
    var cost: Double {
        qty * (feedstock?.priceExVAT ?? 0)
    }
    
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.qty < rhs.qty
    }
}
