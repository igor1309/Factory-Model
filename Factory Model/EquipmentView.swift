//
//  EquipmentView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EquipmentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var equipment: Equipment
    
    init(equipment: Equipment) {
        self.equipment = equipment
    }
    
    private let lifetimes: [Double] = [1, 2, 3, 4, 5, 6, 7, 10]
    
    var body: some View {
        List {
            Section(header: Text("Equipment")) {
                Group {
                    TextField("Name", text: $equipment.name)
                    TextField("Name", text: $equipment.note)
                    
                    Picker("Lifetime", selection: $equipment.lifetime) {
                        ForEach(lifetimes, id: \.self) { lifetime in
                            Text(lifetime.formattedGrouped).tag(lifetime)
                        }
                    }
                    
                    Text("TBD: price: \(equipment.price, specifier: "%.f")")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Amortization")
            ) {
                LabelWithDetail("dollarsign.circle", "Monthly", equipment.amortizationMonthly.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(equipment.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            managedObjectContext.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct EquipmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EquipmentView()
//    }
//}
