//
//  Ingredient.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import Foundation

extension Ingredient: Comparable {
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.qty < rhs.qty
    }
}
