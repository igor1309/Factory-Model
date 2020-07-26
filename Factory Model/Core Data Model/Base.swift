//
//  Base.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Base {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
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
    var feedstocks: [Feedstock] {
        get { (feedstocks_ as? Set<Feedstock> ?? []).sorted() }
        set { feedstocks_ = Set(newValue) as NSSet }
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
        feedstocks
            .reduce(0) { $0 + $1.costExVAT }
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
