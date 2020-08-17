//
//  IngredientCreator.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct IngredientCreator: View {
    @Environment(\.managedObjectContext) private var context
    
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var unitString_: String = ""
    @State private var priceExVAT: Double = 0
    @State private var vat: Double = 10/100
    
    var body: some View {
        List {
            IngredientEditor(name: $name, unitString_: $unitString_, priceExVAT: $priceExVAT, vat: $vat)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(name.isEmpty ? "New Ingredient" : name)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let ingredient = Ingredient(context: context)
                    ingredient.name = name
                    ingredient.unitString_ = unitString_
                    ingredient.priceExVAT = priceExVAT
                    ingredient.vat = vat
                    
                    context.saveContext()
                    isPresented = false
                }
                .disabled(name.isEmpty)
            }
        }
    }
}
