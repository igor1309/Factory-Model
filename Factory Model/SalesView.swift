//
//  SalesView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct SalesView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var sales: Sales
    @ObservedObject var factory: Factory
    
    init(_ sales: Sales, for factory: Factory) {
        self.sales = sales
        self.factory = factory
    }
    
    var body: some View {
        List {
            Text("NEEDS TO BE COMPLETLY REDONE")
                .foregroundColor(.systemRed)
                .font(.headline)
            
            Section(header: Text("")) {
                Group {
                    EntityPicker(selection: $sales.buyer)
                    
                    Picker("Select Existing Buyer", selection: $sales.buyer) {
                        ForEach(factory.buyers, id: \.self) { buyer in
                            Text(buyer)
                        }
                    }
                    
                    LabelWithDetailView("Qty", AmountPicker(navigationTitle: "Select Qty", scale: .large, qty: $sales.qty))
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(sales.buyerName)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}
