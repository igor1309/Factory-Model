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
            header: Text("Product Details")
        ) {
            Group {
                HStack {
                    Text("Name")
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
                    Text("Code")
                        .foregroundColor(.secondary)
                    TextField("Code", text: $product.code)
                        .foregroundColor(.accentColor)
                }
                
                HStack {
                    Text("Note")
                        .foregroundColor(.secondary)
                    TextField("Note", text: $product.note)
                        .foregroundColor(.accentColor)
                }
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Base Product"),
            footer: Text("TBD: на единицу продукта")
                .foregroundColor(.systemRed)
                .font(.headline)
        ) {
            Group {
                EntityPicker(selection: $product.base, icon: Product.icon, predicate: nil)
                
                AmountPicker(title: "Base Qty", navigationTitle: "Qty", scale: .medium, amount: $product.baseQty)
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Packaging")
        ) {
            EntityPicker(selection: $product.packaging, icon: "shippingbox", predicate: nil)
            .font(.subheadline)
        }
        
        Section(
            header: Text("VAT")
        ) {
            Group {
                //  MARK: - FINISH THIS CHANGE SCALE TO PERCENT
                AmountPicker(title: "VAT", navigationTitle: "VAT", scale: .medium, amount: $product.vat)
            }
            .font(.subheadline)
        }
    }
}
