//
//  Ingredient Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import CoreData

extension Ingredient {
    static var example: Ingredient {
        let preview = PersistenceManager.previewContext
        let ingredient = Ingredient(context: preview)
        ingredient.name_ = "Some Ingredient"
        ingredient.priceExVAT = 11
        ingredient.customUnit = .kilogram
        ingredient.vat = 10/100

        return ingredient
    }
}
