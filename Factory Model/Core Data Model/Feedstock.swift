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

    var total: Double {
        qty * price
    }
}

extension Feedstock: Comparable {
    public static func < (lhs: Feedstock, rhs: Feedstock) -> Bool {
        lhs.name < rhs.name
    }
    
    
}
