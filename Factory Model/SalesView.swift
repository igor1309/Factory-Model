//
//  SalesView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct SalesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var sales: Sales
    var factory: Factory
    
    init(_ sales: Sales, for factory: Factory) {
        self.sales = sales
        self.factory = factory
    }
    
    var body: some View {
        List {
            Section(header: Text("")) {
                Group {
                    TextField("Name", text: $sales.buyer)
                    
                    Picker("Select Existing Buyer", selection: $sales.buyer) {
                        ForEach(factory.buyers, id: \.self) { buyer in
                            Text(buyer)
                        }
                    }
                    
                    LabelWithDetailView("Qty", QtyPicker(qty: $sales.qty))
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(sales.buyer)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            managedObjectContext.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct SalesView_Previews: PreviewProvider {
//    static var previews: some View {
//        SalesView()
//    }
//}
