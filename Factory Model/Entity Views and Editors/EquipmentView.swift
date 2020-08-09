//
//  EquipmentView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EquipmentView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var equipment: Equipment
    
    init(_ equipment: Equipment) {
        self.equipment = equipment
    }
    
    private let lifetimes: [Double] = [1, 2, 3, 4, 5, 6, 7, 10]
    
    var body: some View {
        List {
            //  parent check
            if equipment.factory == nil {
                Section(
                    header: Text("Factory")
                ) {
                    EntityPicker(selection: $equipment.factory, icon: "building.2")
                        .foregroundColor(.systemRed)
                }
            }
            

            Section(header: Text("Equipment")) {
                Group {
                    TextField("Name", text: $equipment.name)
                    TextField("Note", text: $equipment.note)
                    
                    AmountPicker(systemName: "sparkles", title: "Lifetime", navigationTitle: "Lifetime", scale: .extraSmall, amount: $equipment.lifetime)
                    
                    AmountPicker(systemName: "dollarsign.circle", title: "Price", navigationTitle: "Price", scale: .extraExtraLarge, amount: $equipment.price)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Depreciation")
            ) {
                LabelWithDetail("dollarsign.circle", "Monthly", equipment.depreciationMonthly.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .onDisappear {
            moc.saveContext()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(equipment.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}
