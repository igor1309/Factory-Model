//
//  Equipment.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Equipment {
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    
    var depreciationMonthly: Double {
        Equipment.depreciationMonthly(price: price, lifetime: lifetime)
    }
    
    //  MARK: more clever/complex depreciation?
    static func depreciationMonthly(price: Double, lifetime: Double) -> Double {
        price / (lifetime > 0 ? lifetime : 1) / 12
    }
}

extension Equipment: Comparable {
    public static func < (lhs: Equipment, rhs: Equipment) -> Bool {
        lhs.name < rhs.name
    }
    
    
}
