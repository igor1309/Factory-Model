//
//  FeedstockView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct FeedstockView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var feedstock: Feedstock

    init(_ feedstock: Feedstock) {
        self.feedstock = feedstock
    }
    
    var body: some View {
        List {
            Text("NEEDS TO BE COMPLETLY REDONE")
                .foregroundColor(.systemRed)
                .font(.headline)
            
            Section(header: Text("Feedstock")) {
                Group {
//                    TextField("Name", text: $feedstock.name)
                    Text("TBD: Qty:")
                    Text("TBD: Price PRICE")
                    Text("TBD: Total Cost")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .onDisappear {
            moc.saveContext()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(feedstock.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}
