//
//  UtilityView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct UtilityView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentation
    
    @ObservedObject var utility: Utility
    
    init(_ utility: Utility) {
        self.utility = utility
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Utility")
            ) {
                TextField("Name", text: $utility.name)
                    .foregroundColor(.accentColor)
                    .font(.subheadline)
            }
            
            Section(
                header: Text("Price"),
                footer: Text("Price per Unit of Base Product")
            ) {
                Group {
                    AmountPicker(systemName: "dollarsign.circle", title: "Utility Price, ex VAT", navigationTitle: "Utility Price", scale: .small, amount: $utility.priceExVAT)
                    
                    AmountPicker(systemName: "scissors", title: "Utility VAT", navigationTitle: "Utility VAT", scale: .percent, amount: $utility.vat)
                    
                    LabelWithDetail("scissors", "incl VAT", utility.priceWithVAT.formattedGrouped)
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
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}
