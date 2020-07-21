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
    
    var priceWithVAT: Double {
        //  MARK: FIX THIS: VAT is project/country constant
        get { price * 1.20 }
        set { price = newValue / 1.20 }
    }
}

extension Sales: Comparable {
    public static func < (lhs: Sales, rhs: Sales) -> Bool {
        lhs.qty < rhs.qty
            && lhs.buyer < rhs.buyer
    }
    

}
