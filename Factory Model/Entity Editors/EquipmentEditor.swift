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
    
    @EnvironmentObject var settings: Settings
    
    @Binding var isPresented: Bool
    
    let equipmentToEdit: Equipment?
    let title: String
    
    init(isPresented: Binding<Bool>, factory: Factory? = nil) {
        _isPresented = isPresented
        
        equipmentToEdit = nil
        
        _name = State(initialValue: "")
        _note = State(initialValue: "")
        _factory = State(initialValue: factory)
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
                    .foregroundColor(lifetime > 0 ? .systemBlue : .systemRed)
                
                AmountPicker(systemName: "dollarsign.circle", title: "Price", navigationTitle: "Price", scale: .extraExtraLarge, amount: $price)
                    .foregroundColor(price > 0 ? .systemBlue : .systemRed)
            }
            
            NoteSection(note: $note)
            
            Section(
                header: Text("Depreciation")
            ) {
                LabelWithDetail("dollarsign.circle", "Depreciation, monthly", depreciationMonthly.formattedGrouped)
                    .foregroundColor(.secondary)
            }
            
            EntityPickerSection(selection: $factory, period: settings.period)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let equipment: Equipment
            if let equipmentToEdit = equipmentToEdit {
                equipment = equipmentToEdit
                equipment.objectWillChange.send()
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

struct EquipmentEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    EquipmentEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 700))
            
            NavigationView {
                VStack {
                    EquipmentEditor(Equipment.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 700))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
