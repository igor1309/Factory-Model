//
//  ProductEditorCore.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI

struct ProductEditorCore: View {
    @ObservedObject var product: Product
    
    init(_ product: Product) {
        self.product = product
    }
    
    var body: some View {
        Section(
            header: Text("Product Title is autogenereated.")
        ) {
            Text(product.title)
                .font(.footnote)
        }
        
        ErrorMessage(product)
        
        Section(
            header: Text("Product Details")
        ) {
            Group {
                HStack {
                    ZStack(alignment: .leading) {
                        Text("Group")
                            .hidden()
                        Text("Name")
                    }
                        .foregroundColor(.secondary)
                    TextField("Name", text: $product.name)
                        .foregroundColor(.accentColor)
                }
                
                if product.productGroups.isEmpty {
                    HStack {
                        Text("Group")
                            .foregroundColor(.secondary)
                        TextField("Group", text: $product.group)
                            .foregroundColor(.accentColor)
                    }
                } else {
                    PickerWithTextField(selection: $product.group, name: "Group", values: product.productGroups)
                }
                
                HStack {
                    ZStack(alignment: .leading) {
                        Text("Group")
                            .hidden()
                        Text("Code")
                    }
                        .foregroundColor(.secondary)
                    TextField("Code", text: $product.code)
                        .foregroundColor(.accentColor)
                }
                
                HStack {
                    ZStack(alignment: .leading) {
                        Text("Group")
                            .hidden()
                        Text("Note")
                    }
                        .foregroundColor(.secondary)
                    TextField("Note", text: $product.note)
                        .foregroundColor(.accentColor)
                }
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Base Product & Qty")
        ) {
            Group {
                EntityPicker(selection: $product.base, icon: Product.icon, predicate: nil)
                
                HStack {
                    AmountPicker(systemName: "square.grid.3x3.middleright.fill", title: "Base Qty", navigationTitle: "Qty", scale: .medium, amount: $product.baseQty)
                        .foregroundColor(product.baseQty <= 0 ? .systemRed : .accentColor)
                        .buttonStyle(PlainButtonStyle())
                    ChildUnitPicker(product)
                        .buttonStyle(PlainButtonStyle())
                }
                .foregroundColor(.accentColor)
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Packaging")
        ) {
            EntityPicker(selection: $product.packaging, icon: "shippingbox", predicate: nil)
                .font(.subheadline)
        }
        .foregroundColor(product.packaging == nil ? .systemRed : .accentColor)
        
        Section(
            header: Text("VAT (\(product.vat.formattedPercentageWith1Decimal))")
        ) {
            Group {
                AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT", scale: .percent, amount: $product.vat)
            }
            .font(.subheadline)
        }
    }
}
