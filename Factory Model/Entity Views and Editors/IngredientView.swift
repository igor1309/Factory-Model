//
//  IngredientView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct IngredientView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var ingredient: Ingredient
    
    init(_ ingredient: Ingredient) {
        self.ingredient = ingredient
    }
    
    var unitHeader: some View {
        let text: String = {
            if let unit = ingredient.unitKinda {
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
                header: Text("Ingredient")
            ) {
                Group {
                    TextField("Name", text: $ingredient.name)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: unitHeader,
                footer: Text("Usef to set Price per Unit.")
            ) {
                Group {
                    MassVolumeUnitSubPicker(unit_: $ingredient.unitSymbol_)
                    //                    HStack {
                    //                        Text(ingredient.unit_ ?? "—")
                    //                            .foregroundColor(.secondary)
                    //                            .font(.subheadline)
                    //
                    //                    }
                    
                    //                Text("unit_: \(ingredient.unit_ ?? "no unit_")")
                    //                Text("unit: \(ingredient.unit == nil ? "not set" : ingredient.unit!.symbol)")
                    //                Text("unitString: \(ingredient.unitString)")
                    
                    //                HStack {
                    //                    Spacer()
                    //
                    //                    ForEach(MassVolumeUnit.allCases, id: \.self) { mvUnit in
                    //                        Button {
                    //                            // ingredient.unit_ = unit.rawValue
                    //                            ingredient.unit_ = mvUnit.unit.symbol
                    //                        } label: {
                    //                            Text(mvUnit.rawValue)
                    //                                .foregroundColor(ingredient.unit == nil ? .accentColor : (ingredient.unit! == mvUnit.unit ? .systemOrange : .accentColor))
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
                    AmountPicker(systemName: "dollarsign.circle", title: "Price, ex VAT", navigationTitle: "Price, ex VAT", scale: .small, amount: $ingredient.priceExVAT)
                    
                    LabelWithDetail("scissors", "Price, with VAT", ingredient.priceWithVAT.formattedGrouped)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("VAT")
            ) {
                AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT", scale: .percent, amount: $ingredient.vat)
                    .foregroundColor(.accentColor)
                    .font(.subheadline)
            }
            
            Section(
                header: Text("Usage"),
                footer: Text("Total for the ingredient used in production.")
            ) {
                Group {
                    LabelWithDetail("wrench.and.screwdriver", "Production Qty", ingredient.productionQty.formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Total Cost, ex VAT", ingredient.totalCostExVat.formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Total Cost, with VAT", ingredient.totalCostWithVat.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Text(ingredient.validationMessage)
                .foregroundColor(ingredient.isValid ? .systemGreen : .systemRed)
        }
        .onDisappear {
            moc.saveContext()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(ingredient.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}
