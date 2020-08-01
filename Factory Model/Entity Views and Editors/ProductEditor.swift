//
//  ProductEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductEditor: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var product: Product
    
    init(_ product: Product) {
        self.product = product
    }
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 2) {
                LabelWithDetail("title", product.title)
                LabelWithDetail("subtitle", product.subtitle)
                LabelWithDetail("detail", product.detail ?? "")
            }
            .foregroundColor(.tertiary)
            .font(.caption2)
            
            ProductEditorCore(product)
            
            Section(
                header: Text("Production Qty")
            ) {
                Group {
                    AmountPicker(systemName: "scissors", title: "Production Qty", navigationTitle: "Qty", scale: .large, amount: $product.productionQty)
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.title)
        .onDisappear {
            moc.saveContext()
        }
    }
}
