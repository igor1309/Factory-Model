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
    



    //  MARK: FIX THIS: неоптимально —
    //  нужно по FetchRequest вытащить список имеющихся групп базовых продуктов (для этой/выбранной фабрики! — возможно функция с параметром по умолчанию?)
    var baseGroups: [String] {
        factory?.bases.map(\.group).removingDuplicates() ?? []
    }
    var productList: String {
        products.map(\.title).joined(separator: "\n")
    }
    
    //  MARK: - Qty
    
    var salesQty: Double {
        products
            .reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.salesQty}
    }
    var productionQty: Double {
        products
            /// умножить количество первичного продукта в упаковке (baseQty) на производимое количество (productionQty)
            .reduce(0) { $0 + $1.baseQtyInBaseUnit * $1.productionQty }
    }
    
    //  MARK: - Revenue & Avg Price
        
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
    

    //  MARK: - Costs per Unit
    
    var ingredientsExVAT: Double {
        recipes
            .map(\.ingredientsExVAT)
            .reduce(0, +)
    }
    
    //  MARK: - FINISH THIS
    var salaryWithTax: Double { 0 }
    
    //  MARK: - FINISH THIS
    var depreciationWithTax: Double { 0 }
    
    //  MARK: Utilities per Unit
    
    var utilitiesExVAT: Double {
        utilities
            .reduce(0) { $0 + $1.priceExVAT }
    }
    var utilitiesWithVAT: Double {
        utilities
            .reduce(0) { $0 + $1.priceExVAT * (1 + $1.vat) }
    }
    
    //  MARK: Full Unit Cost
    
    var cost: Double {
        ingredientsExVAT + salaryWithTax + utilitiesExVAT
    }
    
    //  MARK: - Costs for all sold Products
    
    var salesIngrediensExVAT: Double {
        ingredientsExVAT * salesQty
    }

    var salesSalaryWithTax: Double {
        salaryWithTax * salesQty
    }
    
    var salesUtilitiesExVAT: Double {
        utilitiesExVAT * salesQty
    }
    
    var salesUtilitiesWithVAT: Double {
        utilitiesWithVAT * salesQty
    }
    
    var salesCostExVAT: Double {
        cost * salesQty
    }
    
    var cogs: Double { salesCostExVAT }
    
    //  MARK: - Costs for all produced Products
    
    var productionIngrediensExVAT: Double {
        ingredientsExVAT * productionQty
    }
    
    var productionSalaryWithTax: Double {
        salaryWithTax * productionQty
    }
    
    var productionUtilitiesExVAT: Double {
        utilitiesExVAT * productionQty
    }
    
    var productionUtilitiesWithVAT: Double {
        utilitiesWithVAT * productionQty
    }
    
    var productionCostExVAT: Double {
        cost * productionQty
    }
    

    
    //  MARK: - NOT REALLY MARGIN???
    var margin: Double {
        revenueExVAT - cogs
    }

    //  MARK: - Closing Inventory
    
    var closingInventory: Double {
        initialInventory + productionQty - salesQty
    }
}

extension Base: Comparable {
    public static func < (lhs: Base, rhs: Base) -> Bool {
        lhs.code < rhs.code
    }
}
