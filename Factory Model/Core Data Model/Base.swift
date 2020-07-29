//
//  Base.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

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
    var ingredients: [Ingredient] {
        get { (ingredients_ as? Set<Ingredient> ?? []).sorted() }
        set { ingredients_ = Set(newValue) as NSSet }
    }
    var products: [Product] {
        get { (products_ as? Set<Product> ?? []).sorted() }
        set { products_ = Set(newValue) as NSSet }
    }
    var utilities: [Utility] {
        get { (utilities_ as? Set<Utility> ?? []).sorted() }
        set { utilities_ = Set(newValue) as NSSet }
    }
    
    enum Unit: String, CaseIterable {
        case weight, piece
        
        var idd: String {
            switch self {
                case .piece:
                    return "шт"
                case .weight:
                    return "г"
            }
        }
    }
    
    var unit: Unit {
        get { Unit(rawValue: unit_ ?? "weight") ?? .weight }
        set { unit_ = newValue.rawValue }
    }
    
    var sales: [Sales] {
        products.flatMap { $0.sales }
    }
    
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп базовых продуктов (для этой/выбранной фабрики! — возможно функция с параметром по умолчанию?)
    var baseGroups: [String] {
        factory?.bases.map { $0.group }.removingDuplicates() ?? []
    }
    var productList: String {
        products.map { $0.title }.joined(separator: "\n")
    }
    
    var productionQty: Double {
        products
            /// умножить количество первичного продукта в упаковке (baseQty) на производимое количество (productionQty)
            .reduce(0) { $0 + $1.baseQty * $1.productionQty }
    }
    
    var totalSalesQty: Double {
        sales.reduce(0) { $0 + $1.qty }
    }
    var revenueExVAT: Double {
        sales.reduce(0) { $0 + $1.revenueExVAT }
    }
    var revenueWithVAT: Double {
        sales.reduce(0) { $0 + $1.revenueWithVAT }
    }
    var avgPriceExVAT: Double {
        if totalSalesQty > 0 {
            return revenueExVAT / totalSalesQty
        } else {
            return 0
        }
    }
    var avgPriceWithVAT: Double {
        if totalSalesQty > 0 {
            return revenueWithVAT / totalSalesQty
        } else {
            return 0
        }
    }
    
    var costExVAT: Double {
        ingredients
            .map {
                $0.qty * ($0.feedstock?.priceExVAT ?? 0)
            }
            .reduce(0, +)
    }
    var totalCostExVAT: Double {
        costExVAT * productionQty
    }
    var cogs: Double {
        costExVAT * totalSalesQty
    }
    //  MARK: NOT RAEALLY MARGIN???
    var margin: Double {
        revenueExVAT - cogs
    }
    
    var closingInventory: Double {
        initialInventory + productionQty - totalSalesQty
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
}
