//
//  Something.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import Foundation

struct Something: Hashable, Identifiable, Comparable {
    static func < (lhs: Something, rhs: Something) -> Bool {
        lhs.name < rhs.name
    }
    
    var id: UUID
    var name: String
    var qty: Double
    var cost: Double
    var products: String
}

extension Something {
    var iddFinancialTotal: String {
        "qty: \(qty.formattedGrouped) | cost: \(cost.formattedGrouped)"
    }
}
