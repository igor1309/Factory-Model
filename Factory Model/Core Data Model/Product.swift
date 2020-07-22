//
//  Product.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Product {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    var note: String {
        get { note_ ?? "Unknown"}
        set { note_ = newValue }
    }
    var code: String {
        get { code_ ?? "Unknown"}
        set { code_ = newValue }
    }
    var group: String {
        get { group_ ?? "Unknown"}
        set { group_ = newValue }
    }
    var feedstock: [Feedstock] {
        get { (feedstock_ as? Set<Feedstock> ?? []).sorted() }
        set { feedstock_ = Set(newValue) as NSSet }
    }
    var sales: [Sales] {
        get { (sales_ as? Set<Sales> ?? []).sorted() }
        set { sales_ = Set(newValue) as NSSet }
    }
    var utilities: [Utility] {
        get { (utilities_ as? Set<Utility> ?? []).sorted() }
        set { utilities_ = Set(newValue) as NSSet }
    }
    var packagingCode: String {
        packaging?.code ?? "Unknown"
    }
    
    var totalSalesQty: Double {
        sales.map { $0.qty }.reduce(0, +)
    }
    var revenueExVAT: Double {
        sales
            .map { $0.price * $0.qty }
            .reduce(0, +)
    }
    var avgPriceExVAT: Double {
        if totalSalesQty > 0 {
            return revenueExVAT / totalSalesQty
        } else {
            return 0
        }
    }
    var avgPriceWithVAT: Double {
        avgPriceExVAT * 1.20
    }

    var cost: Double {
        feedstock
            .map { $0.qty * $0.price }
            .reduce(0, +)
    }
    var totalCost: Double {
        cost * productionQty
    }
    var cogs: Double {
        cost * totalSalesQty
    }
    var margin: Double {
        revenueExVAT - cogs
    }
    
    var closingInventory: Double {
        initialInventory + productionQty - totalSalesQty
    }
    
    var totalUtilities: Double {
        utilities
            .map { $0.price }
            .reduce(0, +)
    }
}

extension Product: Comparable {
    public static func < (lhs: Product, rhs: Product) -> Bool {
        lhs.code < rhs.code
    }
}
