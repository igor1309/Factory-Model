//
//  PackagingView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var packaging: Packaging
    
    init(_ packaging: Packaging) {
        self.packaging = packaging
    }
    
    var body: some View {
        List {
            PackagingEditor(name: $packaging.name, type: $packaging.type)
            
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
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(packaging.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    context.saveContext()
                    presentation.wrappedValue.dismiss()
                }
            }
        }
    }
}
