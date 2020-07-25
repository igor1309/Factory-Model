//
//  UtilityView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct UtilityView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var utility: Utility
    
    init(_ utility: Utility) {
        self.utility = utility
    }
    
    var body: some View {
        List {
            Section(header: Text("")) {
                Group {
                    TextField("Name", text: $utility.name)
                    Text("TBD: Price ex VAT: \(utility.priceExVAT, specifier: "%.f")")
                    LabelWithDetail("incl VAT", utility.priceWithVAT.formattedGrouped)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(utility.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            managedObjectContext.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}
