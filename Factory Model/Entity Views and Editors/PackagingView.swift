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
            Section(
                header: Text("Packaging Detail")
            ) {
                NavigationLink(
                    destination: PackagingEditor(packaging)
                ) {
                    ListRow(packaging)
                }
            }
            
            ErrorMessage(packaging)
            
            GenericListSection(
                header: "Used in Products",
                type: Product.self,
                predicate: NSPredicate(format: "%K == %@", #keyPath(Product.packaging), packaging)
            ) { product in
                ProductView(product)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(packaging.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
