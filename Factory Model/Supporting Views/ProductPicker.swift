//
//  ProductPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI
import CoreData

struct ProductPicker: View {
    @Environment(\.managedObjectContext) var moc
    
    @Binding var product: Product?
    
    var factory: Factory
    
    @State private var showPicker = false
    var body: some View {
        Button {
            showPicker = true
        } label: {
            Text(product?.title ?? "--")
        }
        .sheet(isPresented: $showPicker, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
            ProductPickerTable(product: $product, for: factory, in: moc)
        }
    }
}

fileprivate struct ProductPickerTable: View {
    @Environment(\.presentationMode) var presentation
    
    @Binding var product: Product?
    var factory: Factory
    var context: NSManagedObjectContext
    
    init(product: Binding<Product?>, for factory: Factory, in context: NSManagedObjectContext) {
        _product = product
        self.factory = factory
        self.context = context
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(factory.productGroups, id: \.self) { type in
                    Section(
                        header: Text(type)
                    ) {
                        ForEach(factory.productForType(type), id: \.objectID) { product in
                            Button {
                                self.product = product
                                presentation.wrappedValue.dismiss()
                            } label: {
                                Text(product.title).tag(product)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Select Product")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
