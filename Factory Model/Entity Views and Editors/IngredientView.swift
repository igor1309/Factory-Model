//
//  IngredientView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct IngredientView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var ingredient: Ingredient
    
    init(_ ingredient: Ingredient) {
        self.ingredient = ingredient
    }
    
    var unitHeader: some View {
        let text: String = {
            if let unitString_ = ingredient.unitString_ {
                return "Unit (\(unitString_))"
            } else {
                return "Unit"
            }
        }()
        
        return Text(text)
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Ingredient Name")
            ) {
                Group {
                    TextField("Name", text: $ingredient.name)
                    
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Price"),
                footer: Text("Price per Unit. Unit is also used to define Recipe unit type (mass, volume, etc).")
            ) {
                Group {
                    HStack {
                        AmountPicker(systemName: "dollarsign.circle", title: "Price, ex VAT", navigationTitle: "Price, ex VAT", scale: .small, amount: $ingredient.priceExVAT)
                            .buttonStyle(PlainButtonStyle())
                        
                        Text("/")
                        
                        ParentUnitPicker(ingredient)
                            .buttonStyle(PlainButtonStyle())
                    }
                    
                    LabelWithDetail("scissors", "Price, with VAT", ingredient.priceWithVAT.formattedGrouped)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            ErrorMessage(ingredient)
            
            Section(
                header: Text("VAT")
            ) {
                AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT", scale: .percent, amount: $ingredient.vat)
                    .foregroundColor(.accentColor)
                    .font(.subheadline)
            }
            
            Section(
                header: Text("Usage"),
                footer: Text("Total for the Ingredient used in production.")
            ) {
                Group {
                    LabelWithDetail("wrench.and.screwdriver", "Production Qty", ingredient.productionQty.formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Total Cost, ex VAT", ingredient.totalCostExVat.formattedGrouped)
                    LabelWithDetail("dollarsign.square", "Total Cost, with VAT", ingredient.totalCostWithVat.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            GenericListSection(
                header: "Base Products",
                type: Base.self,
                predicate: NSPredicate(format: "ANY %K.ingredient == %@", #keyPath(Base.recipes_), ingredient)
            ) { (base: Base) in
                BaseEditor(base)
            }
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
