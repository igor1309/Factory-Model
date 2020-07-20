//
//  Sales.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Sales {
    var priceWithVAT: Double {
        //  MARK: FIX THIS: VAT is project/country constant
        get { price * 1.20 }
        set { price = newValue / 1.20 }
    }
}
