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
        base.code = "HKL"
        base.customUnit = .piece
        base.weightNetto = 60
        base.complexity = 1
        
        let ingredient1 = Ingredient(context: context)
        ingredient1.name = "Мука"
        //ingredient1.unitString_ = "кило"
        ingredient1.customUnit = .kilogram
        ingredient1.priceExVAT = 20
        ingredient1.vat = 10/100
        
        let recipe1 = Recipe(context: context)
        recipe1.ingredient = ingredient1
        recipe1.qty = 60
        recipe1.coefficientToParentUnit = 1/1_000
        
        let ingredient2 = Ingredient(context: context)
        ingredient2.name = "Мясо"
        //ingredient2.unitString_ = "кило"
        ingredient2.customUnit = .kilogram
        ingredient2.priceExVAT = 300
        ingredient2.vat = 10/100
        
        let recipe2 = Recipe(context: context)
        recipe2.ingredient = ingredient2
        recipe2.qty = 60
        recipe2.coefficientToParentUnit = 1/1_000
        
        base.recipes = [recipe1, recipe2]
        
        context.saveContext()
        
        return base
    }
}
