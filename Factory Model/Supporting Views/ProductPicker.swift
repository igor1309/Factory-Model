//
//  ProductPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI
import CoreData

struct ProductPicker: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var product: Product?
    
    var factory: Factory
    
    @State private var showPicker = false
    var body: some View {
        Button {
            showPicker = true
        } label: {
            Text(product?.idd ?? "--")
        }
        .sheet(isPresented: $showPicker, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
            ProductPickerTable(product: $product, for: factory, in: managedObjectContext)
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
                ForEach(factory.productGroups, id: \.self) { group in
                    Section(
                        header: Text(group)
                    ) {
                        ForEach(factory.productsForGroup(group), id: \.objectID) { product in
                            Button {
                                self.product = product
                                presentation.wrappedValue.dismiss()
                            } label: {
                                Text(product.idd).tag(product)
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

//struct ProductPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductPicker()
//    }
//}
