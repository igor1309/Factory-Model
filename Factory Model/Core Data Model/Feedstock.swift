//
//  Feedstock.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation

extension Feedstock {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }

    var cost: Double {
        qty * price
    }
    
    var idd: String {
        "\(name) \(qty.formattedGrouped) @ \(price.formattedGroupedWithDecimals)"
    }
    
    var iddFinancial: String {
        "\(qty) @ \(price) = \(cost)"
    }
    
    var productName: String {
        product?.name ?? "Unknown"
    }
    var productionQty: Double {
        product?.productionQty ?? 0
    }
}

extension Feedstock: Comparable {
    public static func < (lhs: Feedstock, rhs: Feedstock) -> Bool {
        lhs.name < rhs.name
    }
    
    
}
