//
//  Feedstock.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation

extension Feedstock {
    var priceWithVAT: Double {
        get { priceExVAT * (1 + vat) }
        set { priceExVAT = vat == 0 ? 0 : newValue / vat }
    }
//    var costExVAT: Double {
//        qty * priceExVAT
//    }
//    var baseName: String {
//        base?.name ?? "Unknown"
//    }
//    var productionQty: Double {
//        base?.productionQty ?? 0
//    }
//    var baseQty: Double {
//        base?.products
//            .compactMap { $0.baseQty }
//            .reduce(0) { $0 + $1 } ?? 0
//    }
}

extension Feedstock: Comparable {
    public static func < (lhs: Feedstock, rhs: Feedstock) -> Bool {
        lhs.name < rhs.name
    }
}
