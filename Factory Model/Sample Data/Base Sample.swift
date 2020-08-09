//
//  Base Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import Foundation
import CoreData

extension Base {
    
    static func createBase2_1(in context: NSManagedObjectContext) -> Base {
        let base = Base(context: context)
        base.name = "Хинкали"
        base.group = "Заморозка"
        base.unitString_ = "piece"
        base.weightNetto = 60
        
        let ingredient1 = Ingredient(context: context)
        ingredient1.name = "Мука"
        
        let recipe1 = Recipe(context: context)
        recipe1.ingredient = ingredient1
        
        let ingredient2 = Ingredient(context: context)
        ingredient2.name = "Мясо"
        
        let recipe2 = Recipe(context: context)
        recipe2.ingredient = ingredient2
        
        base.recipes = [recipe1, recipe2]
        
        return base
    }
}
