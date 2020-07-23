//
//  ProductRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

struct ProductRow: View {
    let product: Product
    let useSmallerFont: Bool
    
    init(
        _ product: Product,
        useSmallerFont: Bool = true
    ) {
        self.product = product
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        ListRow(
            title: product.idd,
            subtitle: product.note,
            detail: product.iddFinancial,
            icon: "bag",
            useSmallerFont: useSmallerFont
        )
    }
}
