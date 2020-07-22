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
    
    var comment: String {
        "\(name) \(qty.formattedGrouped) @ \(price.formattedGroupedWithDecimals)"
    }
    
    var productName: String {
        product?.name ?? "Unknown"
    }
}

extension Feedstock: Comparable {
    public static func < (lhs: Feedstock, rhs: Feedstock) -> Bool {
        lhs.name < rhs.name
    }
    
    
}
