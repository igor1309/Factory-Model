//
//  SalesRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

struct SalesRow: View {
    @ObservedObject var sales: Sales
    let useSmallerFont: Bool
    
    init(
        _ sales: Sales,
         useSmallerFont: Bool = true
    ) {
        self.sales = sales
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        ListRow(
            title: sales.buyer,
            subtitle: sales.idd,
            icon: "cart",
            useSmallerFont: useSmallerFont
        )
    }
}
