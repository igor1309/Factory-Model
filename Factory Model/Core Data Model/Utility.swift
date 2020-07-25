//
//  Utility.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import Foundation

extension Utility {
    var name: String {
        get { name_ ?? "Unknown" }
        set { name_ = newValue }
    }
    
    var priceWithVAT: Double {
        get { priceExVAT * (1 + vat) }
        set { priceExVAT = vat == 0 ? 0 : newValue / vat }
    }
}

extension Utility: Comparable {
    public static func < (lhs: Utility, rhs: Utility) -> Bool {
        lhs.name < rhs.name
    }
    
    
}
