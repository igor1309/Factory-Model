//
//  Packaging.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation

extension Packaging {
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
    var type: String {
        get { type_ ?? "No type" }
        set { type_ = newValue }
    }
    var sales: [Sales] {
        get { (sales_ as? Set<Sales> ?? []).sorted() }
        set { sales_ = Set(newValue) as NSSet }
    }
    var productionQty: Double {
        production?.qty ?? 0
    }
    
    var baseDetail: String {
        base == nil
            ? "ERROR: no base for packaging"
            : base!.name
    }
    
    var baseName: String {
        base?.name ?? "ERROR: no base"
    }
    var baseTitle: String {
        base?.title ?? ""
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
}

extension Packaging: Comparable {
    public static func < (lhs: Packaging, rhs: Packaging) -> Bool {
        lhs.code < rhs.code
    }
}
