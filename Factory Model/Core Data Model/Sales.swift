//
//  Sales.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Sales {
    var buyer: String {
        get { buyer_ ?? "Unknown" }
        set { buyer_ = newValue }
    }
    var productName: String {
        product?.name ?? "Unknown"
    }
    
    var priceWithVAT: Double {
        get { priceExVAT * (product?.vat ?? 0) }
        set {
            let vat = (product?.vat ?? 0)
            priceExVAT = vat == 0 ? 0 : newValue / vat
        }
    }
    
    var revenueExVAT: Double {
        qty * priceExVAT
    }
    var revenueWithVAT: Double {
        qty * priceWithVAT
    }
    
    var cogs: Double { product?.cogs ?? 0 }
}

extension Sales: Comparable {
    public static func < (lhs: Sales, rhs: Sales) -> Bool {
        lhs.qty < rhs.qty
            && lhs.buyer < rhs.buyer
    }
}
