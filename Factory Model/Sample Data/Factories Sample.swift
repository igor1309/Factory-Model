//
//  Factories Sample.swift
//  Factory Model
//
//  Created by Igor Malyarov on 09.08.2020.
//

import Foundation
import CoreData

extension Factory {
    
    static func createFactory1(in context: NSManagedObjectContext) -> Factory {
        
        //  MARK: - Factory 1
        
        let factory1 = Factory(context: context)
        factory1.name = "Сыроварня"
        factory1.note = "Тестовый проект"
        factory1.profitTaxRate = 20/100
        factory1.salaryBurdenRate = 30.2/100
        
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
        
        //  MARK: - Recipes for Base Product 1
        
        let recipe1 = Recipe(context: context)
        recipe1.qty = 1
        recipe1.ingredient = milk
        
        let recipe2 = Recipe(context: context)
        recipe2.qty = 1
        recipe2.ingredient = dryMilk
        
        let recipe5 = Recipe(context: context)
        recipe5.qty = 0.5 / 1000
        recipe5.ingredient = rennetFilling
        
        let recipe7 = Recipe(context: context)
        recipe7.qty = 1.5
        recipe7.ingredient = salt
        
        let recipe8 = Recipe(context: context)
        recipe8.qty = 1
        recipe8.ingredient = water
        
        //  MARK: - Base Product 1_1
        
        let base1_1 = Base(context: context)
        base1_1.name = "Сулугуни"
        base1_1.note = "Первый продукт"
        base1_1.code = "1001"
        base1_1.group = "Сыры"
        base1_1.unitString_ = "кило"
        base1_1.weightNetto = 1_000
        base1_1.complexity = 1
        base1_1.recipes = [recipe1, recipe2, recipe5, recipe7, recipe8]
        base1_1.factory = factory1
        
        //  MARK: - Product 1_1
        
        let product1_1 = Product(context: context)
        product1_1.code = "У001"
        product1_1.name = "Ведёрко 1 кг"
        product1_1.note = "..."
        product1_1.baseQty = 1
        product1_1.base = base1_1
        product1_1.group = "Ведёрко"
        product1_1.vat = 10/100
        product1_1.productionQty = 3_000
        
        product1_1.packaging = Packaging(context: context)
        product1_1.packaging?.name = "P1"
        product1_1.packaging?.type = "p01"
        
        //  MARK: - Buyer 1_1
        let buyer1_1 = Buyer(context: context)
        buyer1_1.name_ = "Speelo Group"
        
        //  MARK: - Sales 1_1
        
        let sales1_1 = Sales(context: context)
        sales1_1.priceExVAT = 300
        sales1_1.qty = 1_000
        sales1_1.product = product1_1
        sales1_1.buyer = buyer1_1
        
        //  MARK: - Utility
        
        let utility1 = Utility(context: context)
        utility1.name = "Электроэнергия"
        utility1.priceExVAT = 10
        utility1.vat = 20/100
        
        base1_1.utilities = [utility1]
        
        //  MARK: - Product 1_2
        
        let product1_2 = Product(context: context)
        product1_2.code = "У002"
        product1_2.name = "Вакуум"
        product1_2.note = "..."
        product1_2.baseQty = 750
        product1_2.base = base1_1
        product1_2.coefficientToParentUnit = 1/1_000
        product1_2.group = "Вакуум"
        product1_2.vat = 10/100
        
        product1_2.packaging = Packaging(context: context)
        product1_2.packaging?.name = "P2"
        product1_2.packaging?.type = "p02"
        
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
        base2.factory = factory1
        
        let base3 = Base(context: context)
        base3.name = "Творог"
        base3.code = "2001"
        base3.group = "Твороги"
        base3.unitString_ = "кило"
        base3.weightNetto = 1_000
        base3.complexity = 1
        base3.factory = factory1
        
        let divisions = Division.createSampleDivisions(in: context)
        for division in divisions {
            factory1.addToDivisions_(division)
        }
        
        factory1.expenses = Expenses.createExpenses1(in: context)
        
        let equipment = Equipment(context: context)
        equipment.name = "Сырная линия"
        equipment.note = "Основная производственная линия"
        equipment.price = 7_000_000
        equipment.lifetime = 7
        
        factory1.equipments = [equipment]
        
        context.saveContext()
        
        return factory1
    }
    
    static func createFactory2(in context: NSManagedObjectContext) -> Factory {
        let factory2 = Factory(context: context)
        factory2.name = "Полуфабрикаты"
        factory2.note = "Фабрика Полуфабрикатов: заморозка и прочее"
        factory2.profitTaxRate = 20/100
        factory2.salaryBurdenRate = 30.2/100
        
        let base2_1 = Base.createBase2_1(in: context)
        base2_1.factory = factory2
        
        let metro = Buyer(context: context)
        metro.name_ = "METRO"
        
        let metroSales = Sales(context: context)
        metroSales.buyer = metro
        metroSales.qty = 1_000
        metroSales.priceExVAT = 230
        
        let product2_1 = Product(context: context)
        product2_1.name = "Настоящие"
        product2_1.code = "2001"
        product2_1.baseQty = 12
        product2_1.group = "Контейнер"
        product2_1.vat = 10/100
                
        product2_1.packaging = Packaging(context: context)
        product2_1.packaging?.name = "P3"
        product2_1.packaging?.type = "p03"
        
        product2_1.sales = [metroSales]
        product2_1.base = base2_1
        
        context.saveContext()
        
        return factory2
    }
}
