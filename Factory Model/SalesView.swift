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
    
    var sales: Sales
    var factory: Factory
    
    @State private var draft: Sales
    
    init(_ sales: Sales, for factory: Factory) {
        self.sales = sales
        self.factory = factory
        _draft = State(initialValue: sales)
    }
    
    var body: some View {
        List {
            Section(header: Text("")) {
                Group {
                    TextField("Name", text: $draft.buyer)
                    
                    Picker("Existing Buyer", selection: $draft.buyer) {
                        ForEach(factory.buyers, id: \.self) { buyer in
                            Text(buyer)
                        }
                    }

                    LabelWithDetailView("Sales", QtyPicker(qty: $draft.qty))
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.buyer)
    }
}

//struct SalesView_Previews: PreviewProvider {
//    static var previews: some View {
//        SalesView()
//    }
//}
