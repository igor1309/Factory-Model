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
            Section(
                header: Text("Feedstock")
            ) {
                Group {
                    TextField("Name", text: $feedstock.name)
                    
                    AmountPicker(systemName: "puzzlepiece", title: "Price ex VAT", navigationTitle: "Price ex VAT", scale: .small, amount: $feedstock.priceExVAT)
                    
                    LabelWithDetail("scissors", "Price with VAT", feedstock.priceWithVAT.formattedGrouped)
                        .foregroundColor(.secondary)

                    //  MARK: - add .percent to AmountPicker
                    AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT", scale: .extraSmall, amount: $feedstock.vat)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Feedstock")
            ) {
                Group {
                    LabelWithDetail("wrench.and.screwdriver", "Production Qty", feedstock.productionQty.formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Total Cost ex VAT", feedstock.totalCostExVat.formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Total Cost with VAT", feedstock.totalCostWithVat.formattedGrouped)
                }
                .foregroundColor(.secondary)
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
