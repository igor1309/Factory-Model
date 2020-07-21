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
}

extension Utility: Comparable {
    public static func < (lhs: Utility, rhs: Utility) -> Bool {
        lhs.name < rhs.name
    }
    
    
}
