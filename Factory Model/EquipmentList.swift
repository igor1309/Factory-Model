//
//  EquipmentList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EquipmentList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var equipments: FetchedResults<Equipment>
    
    var factory: Factory
    
    init(at factory: Factory) {
        self.factory = factory
        
        _equipments = Equipment.defaultFetchRequest(for: factory)
    }
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                Group {
                    LabelWithDetail("wrench.and.screwdriver", "Salvage Value", "TBD")
                        .foregroundColor(.primary)

                    /// https://www.investopedia.com/terms/a/accumulated-depreciation.asp
                    LabelWithDetail("wrench.and.screwdriver", "Accumulated Depreciation", "TBD")

                    LabelWithDetail("wrench.and.screwdriver", "Cost basis", factory.equipmentTotal.formattedGrouped)
                    
                    LabelWithDetail("dollarsign.circle", "Amortization, monthly", factory.depreciationMonthly.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(header: Text("Equipment")) {
                ForEach(equipments, id: \.objectID) { equipment in
                    NavigationLink(
                        destination: EquipmentView(equipment: equipment)
                    ) {
                        ListRow(equipment)
                    }
                }
                .onDelete(perform: removeEquipment)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Equipment")
//        .navigationBarItems(trailing: PPlusEntityButton<Equipment>(factory: factory))
        .navigationBarItems(trailing: PlusButton(parent: factory, path: "equipments_", keyPath: \Equipment.factory!))

    }
    
    private func removeEquipment(at offsets: IndexSet) {
        for index in offsets {
            let expense = equipments[index]
            moc.delete(expense)
        }
        moc.saveContext()
    }
}
