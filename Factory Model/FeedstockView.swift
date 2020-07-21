//
//  FeedstockView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct FeedstockView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    var feedstock: Feedstock
    var product: Product

    @State private var draft: Feedstock
    
    init(feedstock: Feedstock, for product: Product) {
        self.feedstock = feedstock
        self.product = product
        _draft = State(initialValue: feedstock)
    }
    
    var body: some View {
        List {
            Section(header: Text("Feedstock".uppercased())) {
                Group {
                    TextField("Name", text: $draft.name)
                    Text("TBD: Qty: \(draft.qty, specifier: "%.f")")
                    Text("TBD: Price PRICE")
                    Text("TBD: Total Cost")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
    }
}

//struct FeedstockView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedstockView()
//    }
//}
