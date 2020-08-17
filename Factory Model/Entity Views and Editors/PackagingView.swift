//
//  PackagingView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingEditor: View {
    @Binding var name: String
    @Binding var type: String
    
    var body: some View {
        Section(
            header: Text(name.isEmpty ? "" : "Edit Packaging Name")
        ) {
            TextField("Packaging Name", text: $name)
        }
        
        PickerWithTextField(selection: $type, name: "Type", values: ["TBD"])
    }
}

struct PackagingView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var packaging: Packaging
    
    init(_ packaging: Packaging) {
        self.packaging = packaging
    }
    
    var body: some View {
        List {
            PackagingEditor(name: $packaging.name, type: $packaging.type)
//            Section(
//                header: Text("Packaging Details")
//            ) {
//                Group {
//                    HStack {
//                        Text("Name")
//                            .foregroundColor(.tertiary)
//
//                        TextField("Name", text: $packaging.name)
//                    }
//
//                    PickerWithTextField(selection: $packaging.type, name: "Type", values: ["TBD"])
//                }
//                .foregroundColor(.accentColor)
//                .font(.subheadline)
//            }
            
            Section(
                header: Text("Used in Products")
            ) {
                Group {
                    Text(packaging.productList)
                        .foregroundColor(packaging.isValid ? .secondary : .systemRed)
                }
                .font(.caption)
            }
            
            GenericListSection(
                header: "Оставлять ли этот список?",
                type: Product.self,
                predicate: NSPredicate(format: "%K == %@", #keyPath(Product.packaging), packaging)
            ) { product in
                ProductView(product)
            }
        }
        .onDisappear {
            moc.saveContext()
            print("onDisappear: moc.saveContext()")
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(packaging.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
