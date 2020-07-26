//
//  Equipment.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.07.2020.
//

import Foundation

extension Equipment {
    var name: String {
        get { name_ ?? "Unknown"}
        set { name_ = newValue }
    }
    var note: String {
        get { note_ ?? ""}
        set { note_ = newValue }
    }
    
    var depreciationMonthly: Double {
        price / (lifetime > 0 ? lifetime : 1) / 12
    }
}

extension Equipment: Comparable {
    public static func < (lhs: Equipment, rhs: Equipment) -> Bool {
        lhs.name < rhs.name
    }
    
    
}
