//
//  ProductEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct ProductEditor: View {
    @ObservedObject var product: Product

    init(_ product: Product) {
        self.product = product
    }
    
    var body: some View {
        List {
            Section(header: Text("Product")) {
                Group {
                    TextField("Name", text: $product.name)
                    TextField("Group", text: $product.group)
                    TextField("Code", text: $product.code)
                    TextField("Note", text: $product.note)
                    
                    LabelWithDetail("TBD: Weight Netto", product.weightNetto.formattedGroupedWith1Decimal)
                    
                    LabelWithDetail("TBD: Packaging", product.packagingCode)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(header: Text("Feedstock")) {
                NavigationLink(
                    destination: FeedstockList(for: product)
                ) {
                    LabelWithDetail("puzzlepiece", "Feedstock Cost", product.cost.formattedGrouped)
                        .font(.subheadline)
                }
                .foregroundColor(.accentColor)
            }
            
            Section(header: Text("Utilities")) {
                NavigationLink(
                    destination: UtilityList(for: product)
                ) {
                    LabelWithDetail("lightbulb", "Total Utilities", "TBD")
                        .font(.subheadline)
                }
                .foregroundColor(.accentColor)
            }

        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.name)
    }
}

//struct ProductEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductEditor()
//    }
//}
