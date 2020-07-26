//
//  Product.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation

extension Product {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    var code: String {
        get { code_ ?? "No code"}
        set { code_ = newValue }
    }
    var note: String {
        get { note_ ?? "" }
        set { note_ = newValue }
    }
    var group: String {
        get { group_ ?? "No group" }
        set { group_ = newValue }
    }
    var sales: [Sales] {
        get { (sales_ as? Set<Sales> ?? []).sorted() }
        set { sales_ = Set(newValue) as NSSet }
    }

    var weightNetto: Double {
        (base?.weightNetto ?? 0) * baseQty
    }
        
    var baseName: String {
        base?.name ?? "ERROR: no base"

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
        totalSalesQty > 0 ? revenueExVAT / totalSalesQty : 0
    }
    var avgPriceWithVAT: Double { avgPriceExVAT * (1 + vat) }
    
    var cogs: Double { (base?.cogs ?? 0) * baseQty }
    
    //  MARK: FIX THIS: неоптимально — мне нужно по FetchRequest вытащить список имеющихся групп продуктов (для этой/выбранной фабрики!)
    var productGroups: [String] {
        base?.factory?.productGroups ?? []
    }
}

extension Product: Comparable {
    public static func < (lhs: Product, rhs: Product) -> Bool {
        lhs.code < rhs.code
    }
}
