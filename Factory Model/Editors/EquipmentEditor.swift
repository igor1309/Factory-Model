//
//  EquipmentEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct EquipmentEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let equipmentToEdit: Equipment?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        equipmentToEdit = nil
        
        _name = State(initialValue: "")
        _note = State(initialValue: "")
        _factory = State(initialValue: nil)
        _lifetime = State(initialValue: 7)
        _price = State(initialValue: 0)
        
        title = "New Equipment"
    }
    
    init(_ equipment: Equipment) {
        _isPresented = .constant(true)
        
        equipmentToEdit = equipment
        
        _name = State(initialValue: equipment.name)
        _note = State(initialValue: equipment.note)
        _factory = State(initialValue: equipment.factory)
        _lifetime = State(initialValue: equipment.lifetime)
        _price = State(initialValue: equipment.price)
        
        title = "Edit Equipment"
    }
    
    @State private var name: String
    @State private var note: String
    @State private var factory: Factory?
    @State private var lifetime: Double
    @State private var price: Double
    
    private var depreciationMonthly: Double {
        Equipment.depreciationMonthly(price: price, lifetime: lifetime)
    }
    
    var body: some View {
        List {
            NameSection<Equipment>(name: $name)
            
            Section {
                AmountPicker(systemName: "sparkles", title: "Lifetime, years", navigationTitle: "Lifetime", scale: .extraSmall, amount: $lifetime)
                
                AmountPicker(systemName: "dollarsign.circle", title: "Price", navigationTitle: "Price", scale: .extraExtraLarge, amount: $price)
            }
            
            TextField("Note", text: $note)
                .foregroundColor(.accentColor)
            
            Section(
                header: Text("Depreciation")
            ) {
                LabelWithDetail("dollarsign.circle", "Depreciation, monthly", depreciationMonthly.formattedGrouped)
                    .foregroundColor(.secondary)
            }
            
            EntityPickerSection(selection: $factory)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let equipment: Equipment
                    if let equipmentToEdit = equipmentToEdit {
                        equipment = equipmentToEdit
                    } else {
                        equipment = Equipment(context: context)
                    }
                    
                    equipment.name = name
                    equipment.note = note
                    equipment.factory = factory
                    equipment.lifetime = lifetime
                    equipment.price = price
                    
                    context.saveContext()
                    
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(factory == nil || name.isEmpty || price == 0)
            }
        }
    }
}
