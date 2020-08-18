//
//  IngredientEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 17.08.2020.
//

import SwiftUI

struct IngredientEditor: View {
    @Environment(\.managedObjectContext) private var context
    
    @Binding var isPresented: Bool
    
    let ingredientToEdit: Ingredient?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        ingredientToEdit = nil
        _name = State(initialValue: "")
        _unitString_ = State(initialValue: "")
        _priceExVAT = State(initialValue: 0)
        _vat = State(initialValue: 10/100)
        title = "New Ingredient"
    }
    
    init(ingredient: Ingredient) {
        _isPresented = .constant(true)
        ingredientToEdit = ingredient
        _name = State(initialValue: ingredient.name)
        _unitString_ = State(initialValue: ingredient.unitString_ ?? "")
        _priceExVAT = State(initialValue: ingredient.priceExVAT)
        _vat = State(initialValue: ingredient.vat)
        title = "Edit Ingredient"
    }
    
    @State private var name: String
    @State private var unitString_: String
    @State private var priceExVAT: Double
    @State private var vat: Double
    
    var body: some View {
        List {
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
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(name.isEmpty ? "New Ingredient" : name)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let ingredient: Ingredient
                    if let ingredientToEdit = ingredientToEdit {
                        ingredient = ingredientToEdit
                    } else {
                        ingredient = Ingredient(context: context)
                    }
                    
                    ingredient.name = name
                    ingredient.unitString_ = unitString_
                    ingredient.priceExVAT = priceExVAT
                    ingredient.vat = vat
                    
                    context.saveContext()
                    isPresented = false
                }
                .disabled(name.isEmpty || unitString_.isEmpty || priceExVAT == 0)
            }
        }
    }
}
