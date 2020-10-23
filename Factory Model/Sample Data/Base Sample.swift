//
//  Base Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import Foundation
import CoreData

extension Base {
    
    static func createBaseKhinkali(in context: NSManagedObjectContext) -> Base {
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
    
    static func createFactory1Bases(in context: NSManagedObjectContext) -> [Base] {
        
        //  MARK: - Ingredients @ Factory 1
        
        let milk = Ingredient(context: context)
        milk.name = "Молоко натуральное"
        milk.unitString_ = "литр"
        milk.priceExVAT = 30.0
        milk.vat = 10/100
        
        let dryMilk = Ingredient(context: context)
        dryMilk.name = "Сухое молоко"
        dryMilk.unitString_ = "кило"
        dryMilk.priceExVAT = 70
        dryMilk.vat = 10/100
        
        let calciumChloride = Ingredient(context: context)
        calciumChloride.name = "Хлористый кальций"
        calciumChloride.unitString_ = "грамм"
        calciumChloride.vat = 10/100
        
        let bacterialRefueling = Ingredient(context: context)
        bacterialRefueling.name = "Бактериальная заправка"
        bacterialRefueling.unitString_ = "грамм"
        bacterialRefueling.vat = 10/100
        
        let rennetFilling = Ingredient(context: context)
        rennetFilling.name = "Сычужная заправка (?)"
        rennetFilling.unitString_ = "кило"
        rennetFilling.priceExVAT = 8000
        rennetFilling.vat = 10/100
        
        let pepsin = Ingredient(context: context)
        pepsin.name = "Пепсин"
        pepsin.unitString_ = "грамм"
        pepsin.vat = 10/100
        
        let salt = Ingredient(context: context)
        salt.name = "Соль"
        salt.unitString_ = "кило"
        salt.priceExVAT = 20
        salt.vat = 10/100
        
        let water = Ingredient(context: context)
        water.name = "Вода"
        water.unitString_ = "литр"
        water.priceExVAT = 1
        water.vat = 10/100
        
        
        //  MARK: - Base Product 1_1
        
        //  MARK: Recipes for Base Product 1_1
        
        let recipe1 = Recipe(context: context)
        recipe1.ingredient = milk
        recipe1.qty = 1
        
        let recipe2 = Recipe(context: context)
        recipe2.ingredient = dryMilk
        recipe2.qty = 1
        
        let recipe5 = Recipe(context: context)
        recipe5.ingredient = rennetFilling
        recipe5.qty = 0.5 / 1000
        
        let recipe7 = Recipe(context: context)
        recipe7.ingredient = salt
        recipe7.qty = 1.5
        
        let recipe8 = Recipe(context: context)
        recipe8.ingredient = water
        recipe8.qty = 1
        
        
        //  MARK: Base 1_1
        
        let base1_1 = Base(context: context)
        base1_1.name = "Сулугуни"
        base1_1.note = "Первый продукт"
        base1_1.code = "1001"
        base1_1.group = "Сыры"
        base1_1.unitString_ = "кило"
        base1_1.weightNetto = 1_000
        base1_1.complexity = 1
        base1_1.recipes = [recipe1, recipe2, recipe5, recipe7, recipe8]
        
        
        //  MARK: Utility
        
        let utility1 = Utility(context: context)
        utility1.name = "Электроэнергия"
        utility1.priceExVAT = 10
        utility1.vat = 20/100
        
        base1_1.utilities = [utility1]
        
        
        //  MARK: - Base 2
        
        let recipe21 = Recipe(context: context)
        recipe21.qty = 2
        recipe21.ingredient = water
        
        let base2 = Base(context: context)
        base2.name = "Имеретинский"
        base2.code = "1002"
        base2.group = "Сыры"
        base2.unitString_ = "кило"
        base2.weightNetto = 1_000
        base2.complexity = 1
        base2.addToRecipes_(recipe21)
        
        
        //  MARK: - Base 3
        
        let base3 = Base(context: context)
        base3.name = "Творог"
        base3.code = "2001"
        base3.group = "Твороги"
        base3.unitString_ = "кило"
        base3.weightNetto = 1_000
        base3.complexity = 1
        
        
        return [base1_1, base2, base3]
    }
}
