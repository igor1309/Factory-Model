//
//  Something.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import Foundation

struct Something: Hashable, Identifiable {
    var id: UUID
    
    var title: String
    var qty: Double
    var cost: Double
    var detail: String?
    var icon: String = "puzzlepiece"
}

extension Something: Comparable {
    static func < (lhs: Something, rhs: Something) -> Bool {
        lhs.title < rhs.title
    }
}

extension Something: Summarizable {
    var subtitle: String {
        "qty: \(qty.formattedGrouped) | cost: \(cost.formattedGrouped)"
    }
}
