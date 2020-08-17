//
//  ProductEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var product: Product
    
    init(_ product: Product) {
        self.product = product
    }
    
    var body: some View {
        List {
            ProductEditorCore(product)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.title)
        .navigationBarItems(
            trailing: Button("Save") {
                context.saveContext()
                presentation.wrappedValue.dismiss()
            }
        )
        .onDisappear {
            context.saveContext()
        }
    }
}
