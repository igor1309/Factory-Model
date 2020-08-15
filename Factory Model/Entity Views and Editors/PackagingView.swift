//
//  PackagingView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var packaging: Packaging
    
    init(_ packaging: Packaging) {
        self.packaging = packaging
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Packaging Details")
            ) {
                Group {
                    HStack {
                        Text("Name")
                            .foregroundColor(.secondary)
                        
                        TextField("Name", text: $packaging.name)
                    }
                    
                    PickerWithTextField(selection: $packaging.type, name: "Type", values: ["TBD"])
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
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
