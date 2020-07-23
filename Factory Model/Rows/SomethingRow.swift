//
//  SomethingRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

struct SomethingRow: View {
    let something: Something
    let icon: String
    let useSmallerFont: Bool
    
    init(
        _ something: Something,
        icon: String,
        useSmallerFont: Bool = true
    ) {
        self.something = something
        self.icon = icon
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        ListRow(
            title: something.name,
            subtitle: something.iddFinancialTotal,
            detail: something.products,
            icon: icon,
            useSmallerFont: useSmallerFont
        )
    }
}
