//
//  ProductEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductEditor: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var product: Product
    
    var body: some View {
        List {
            
            Text("NEEDS TO BE COMPLETLY REDONE")
                .foregroundColor(.systemRed)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 2) {
                LabelWithDetail("title", product.title)
                LabelWithDetail("subtitle", product.subtitle)
                LabelWithDetail("detail", product.detail ?? "")
            }
            .foregroundColor(.tertiary)
            .font(.footnote)
            
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
                header: Text("")
            ) {
                Group {
                    LabelWithDetail("baseQty", product.baseQty.formattedGrouped)
                        .foregroundColor(.accentColor)
                    LabelWithDetail("VAT", product.vat.formattedPercentage)
                        .foregroundColor(.accentColor)
                }
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.title)
    }
}
