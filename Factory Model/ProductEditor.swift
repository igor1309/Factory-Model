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
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 2) {
                LabelWithDetail("title", product.title)
                LabelWithDetail("subtitle", product.subtitle)
                LabelWithDetail("detail", product.detail ?? "")
            }
            .foregroundColor(.tertiary)
            .font(.caption2)
            
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
                header: Text("Base Qty"),
                footer: Text("TBD: на единицу продукта")
            ) {
                Group {
                    AmountPicker(title: "Base Qty", navigationTitle: "Qty", scale: .medium, amount: $product.baseQty)
                        .font(.subheadline)
                }
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
