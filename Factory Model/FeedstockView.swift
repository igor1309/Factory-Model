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
    
    @ObservedObject var feedstock: Feedstock

    init(feedstock: Feedstock) {
        self.feedstock = feedstock
    }
    
    var body: some View {
        List {
            Section(header: Text("Feedstock")) {
                Group {
                    TextField("Name", text: $feedstock.name)
                    Text("TBD: Qty: \(feedstock.qty, specifier: "%.f")")
                    Text("TBD: Price PRICE")
                    Text("TBD: Total Cost")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(feedstock.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            managedObjectContext.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct FeedstockView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedstockView()
//    }
//}
