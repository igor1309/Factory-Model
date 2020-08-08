//
//  Base.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation
import CoreData

extension Base {
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    var code: String {
        get { code_ ?? "No code"}
        set { code_ = newValue }
    }
    var group: String {
        get { group_ ?? " No group"}
        set { group_ = newValue }
    }
    var recipes: [Recipe] {
        get { (recipes_ as? Set<Recipe> ?? []).sorted() }
        set { recipes_ = Set(newValue) as NSSet }
    }
    var products: [Product] {
        get { (products_ as? Set<Product> ?? []).sorted() }
        set { products_ = Set(newValue) as NSSet }
    }
    var utilities: [Utility] {
        get { (utilities_ as? Set<Utility> ?? []).sorted() }
        set { utilities_ = Set(newValue) as NSSet }
    }
    

    
    
    var customUnit: CustomUnit? {
        get { CustomUnit(rawValue: unitString_ ?? "") }
        set { unitString_ = newValue?.rawValue }
    }
    



    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп базовых продуктов (для этой/выбранной фабрики! — возможно функция с параметром по умолчанию?)
    var baseGroups: [String] {
        factory?.bases.map { $0.group }.removingDuplicates() ?? []
    }
    var productList: String {
        products.map { $0.title }.joined(separator: "\n")
    }
    
    var salesQty: Double {
        products
            .reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.salesQty}
    }
    var productionQty: Double {
        products
            /// умножить количество первичного продукта в упаковке (baseQty) на производимое количество (productionQty)
            .reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.productionQty }
    }
        
    var revenueExVAT: Double {
        products.reduce(0) { $0 + $1.revenueExVAT }
    }
    var revenueWithVAT: Double {
        products.reduce(0) { $0 + $1.revenueWithVAT }
    }
    var avgPriceExVAT: Double {
        if salesQty > 0 {
            return revenueExVAT / salesQty
        } else {
            return 0
        }
    }
    var avgPriceWithVAT: Double {
        salesQty > 0 ? revenueWithVAT / salesQty : 0
    }
    
    var recipesCostExVAT: Double {
        recipes
            .map { $0.qty * ($0.ingredient?.priceExVAT ?? 0) }
            .reduce(0, +)
    }
    var totalCostExVAT: Double {
        recipesCostExVAT * productionQty
    }
    var cogs: Double {
        recipesCostExVAT * salesQty
    }
    //  MARK: NOT REALLY MARGIN???
    var margin: Double {
        revenueExVAT - cogs
    }
    
    var closingInventory: Double {
        initialInventory + productionQty - salesQty
    }
    
    var totalUtilitiesExVAT: Double {
        utilities.reduce(0) { $0 + $1.priceExVAT }
    }
    var totalUtilitiesWithVAT: Double {
        utilities.reduce(0) { $0 + $1.priceExVAT * $1.vat}
    }
}

extension Base: Comparable {
    public static func < (lhs: Base, rhs: Base) -> Bool {
        lhs.code < rhs.code
    }
    
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
