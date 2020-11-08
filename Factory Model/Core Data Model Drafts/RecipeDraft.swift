//
//  RecipeDraft.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.08.2020.
//

import CoreData

struct RecipeDraft: Identifiable {
    var ingredient: Ingredient
    var qty: Double
    var coefficientToParentUnit: Double
    
    var id: NSManagedObjectID { ingredient.objectID }
}

extension RecipeDraft {
    static var example: RecipeDraft {
        RecipeDraft(ingredient: Ingredient.example, qty: 10, coefficientToParentUnit: 1)
    }
}
