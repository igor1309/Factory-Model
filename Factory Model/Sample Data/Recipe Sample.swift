//
//  Recipe Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import CoreData

extension Recipe {
    static var example: Recipe {
        let preview = PersistenceManager.previewContext
        let recipe = Recipe(context: preview)
        recipe.qty = 100
        recipe.customUnit = .gram
        recipe.ingredient = Ingredient.example
        recipe.base = Base.example
        
        return recipe
    }
}
