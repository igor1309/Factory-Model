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
    var detail: String?
    var qty: Double
    var cost: Double
    
    static var icon: String = "puzzlepiece"
}

extension Something: Comparable {
    static func < (lhs: Something, rhs: Something) -> Bool {
        lhs.title < rhs.title
    }
}

extension Something: Summarizable {
    func title(in period: Period) -> String {
        title
    }
    func subtitle(in period: Period) -> String {
        "qty: \(qty.formattedGrouped) | cost: \(cost.formattedGrouped)"
    }
    func detail(in period: Period) -> String? {
        detail
    }
    
    static var headline: String { "Something" }
}
