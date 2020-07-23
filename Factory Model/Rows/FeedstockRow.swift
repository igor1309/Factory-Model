//
//  FeedstockRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

struct FeedstockRow: View {
    let feedstock: Feedstock
    let useSmallerFont: Bool
    
    init(
        _ feedstock: Feedstock,
        useSmallerFont: Bool = true
    ) {
        self.feedstock = feedstock
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        ListRow(
            title: feedstock.name,
            subtitle: feedstock.iddFinancial,
            icon: "puzzlepiece",
            useSmallerFont: useSmallerFont
        )
    }
}
