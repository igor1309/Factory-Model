//
//  SalesEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct SalesEditor: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var sales: Sales
    
    var body: some View {
        List {
            Text("NEEDS TO BE COMPLETLY REDONE")
                .foregroundColor(.systemRed)
                .font(.headline)
            
            
            Section(header: Text("")) {
                Group {
//                    TextField("Name", text: $sales.buyer)
                    
                    if sales.product != nil,
                       sales.product!.base != nil,
                       sales.product!.base!.factory != nil {
                        Picker("Existing Buyer", selection: $sales.buyer) {
                            //  MARK: CHANGE TO FETCH REQUEST
                            ForEach(sales.product!.base!.factory!.buyers, id: \.self) { buyer in
                                Text(buyer)
                            }
                        }
                        .labelsHidden()
                        
                        ProductPicker(product: $sales.product, factory: sales.product!.base!.factory!)
                    }
                    
                    EntityPicker(selection: $sales.product)
                    
                    LabelWithDetail("Price", "TBD")
                    
                    LabelWithDetailView("Qty", QtyPicker(scale: .large, qty: $sales.qty))
                }
                //                .foregroundColor(.accentColor)
                //                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Sales Editor")
        .onDisappear {
            moc.saveContext()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}
