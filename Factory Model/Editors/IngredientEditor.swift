//
//  IngredientEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct IngredientEditor: View {
    @Binding var name: String
    @Binding var unitString_: String
    @Binding var priceExVAT: Double
    @Binding var vat: Double
    
    var body: some View {
        Section(
            header: Text(name.isEmpty ? "" : "Edit Ingredient Name")
        ) {
            TextField("Ingredient Name", text: $name)
        }
        
        Section(
            header: Text("Price"),
            footer: Text("Price per Unit. Unit is also used to define Recipe unit type (mass, volume, etc).")
        ) {
            HStack {
                AmountPicker(systemName: "dollarsign.circle", title: "Price, ex VAT", navigationTitle: "Price, ex VAT", scale: .small, amount: $priceExVAT)
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(priceExVAT == 0 ? .systemRed : .accentColor)
                
                Text("/").foregroundColor(.tertiary)
                
                ParentUnitStringPicker(unitString: $unitString_)
            }
        }
        
        Section(
            header: Text("VAT")
        ) {
            AmountPicker(systemName: "scissors", title: "VAT", navigationTitle: "VAT", scale: .percent, amount: $vat)
                .foregroundColor(.accentColor)
        }
    }
}
