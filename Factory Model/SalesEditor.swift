//
//  SalesEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct SalesEditor: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var sales: Sales

    var body: some View {
        List {
            Section(header: Text("")) {
                Group {
                    TextField("Name", text: $sales.buyer)
                    
                    Picker("Existing Buyer", selection: $sales.buyer) {
                        ForEach(sales.product!.factory!.buyers, id: \.self) { buyer in
                            Text(buyer)
                        }
                    }
                    .labelsHidden()
                    
                    ProductPicker(product: $sales.product, factory: sales.product!.factory!)
                    
                    LabelWithDetail("Price", "TBD")
                    
                    LabelWithDetailView("Qty", QtyPicker(qty: $sales.qty))
                }
//                .foregroundColor(.accentColor)
//                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Sales Editor")
//        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            managedObjectContext.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct SalesEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        SalesEditor()
//    }
//}
