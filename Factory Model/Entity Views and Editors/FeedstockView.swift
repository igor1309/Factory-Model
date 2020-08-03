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
    
    var unitHeader: some View {
        let text: String = {
            if let unit = feedstock.unit {
                return "Unit (\(unit.symbol))"
            } else {
                return "Unit"
            }
        }()
        
        return Text(text)
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Feedstock")
            ) {
                Group {
                    TextField("Name", text: $feedstock.name)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: unitHeader,
                footer: Text("Usef to set Price per Unit.")
            ) {
                Group {
                    MassVolumeUnitSubPicker(unit_: $feedstock.unit_)
                    //                    HStack {
                    //                        Text(feedstock.unit_ ?? "—")
                    //                            .foregroundColor(.secondary)
                    //                            .font(.subheadline)
                    //
                    //                    }
                    
                    //                Text("unit_: \(feedstock.unit_ ?? "no unit_")")
                    //                Text("unit: \(feedstock.unit == nil ? "not set" : feedstock.unit!.symbol)")
                    //                Text("unitString: \(feedstock.unitString)")
                    
                    //                HStack {
                    //                    Spacer()
                    //
                    //                    ForEach(MassVolumeUnit.allCases, id: \.self) { mvUnit in
                    //                        Button {
                    //                            // feedstock.unit_ = unit.rawValue
                    //                            feedstock.unit_ = mvUnit.unit.symbol
                    //                        } label: {
                    //                            Text(mvUnit.rawValue)
                    //                                .foregroundColor(feedstock.unit == nil ? .accentColor : (feedstock.unit! == mvUnit.unit ? .systemOrange : .accentColor))
                    //                        }
                    //                        Spacer()
                    //                    }
                    //                }
                    //                .font(.subheadline)
                    //                .buttonStyle(PlainButtonStyle())
                }
            }
            
            Section(
                header: Text("Price"),
                footer: Text("Price per Unit.")
            ) {
                Group {
                    AmountPicker(systemName: "dollarsign.circle", title: "Price ex VAT", navigationTitle: "Price ex VAT", scale: .small, amount: $feedstock.priceExVAT)
                    
                    LabelWithDetail("scissors", "Price with VAT", feedstock.priceWithVAT.formattedGrouped)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("VAT")
            ) {
                //  MARK: - add .percent to AmountPicker
                AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT TBD %%", scale: .extraSmall, amount: $feedstock.vat)
                    .foregroundColor(.accentColor)
                    .font(.subheadline)
            }
            
            Section(
                header: Text("Usage"),
                footer: Text("Total for the feedstock used in production.")
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
