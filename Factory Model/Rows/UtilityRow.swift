//
//  UtilityRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

struct UtilityRow: View {
    let utility: Utility
    let useSmallerFont: Bool
    
    init(
        _ something: Utility,
        useSmallerFont: Bool = true
    ) {
        self.utility = something
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        ListRow(
            title: utility.name,
            subtitle: "\(utility.price)",
            icon: "lightbulb",
            useSmallerFont: useSmallerFont
        )
    }
}
