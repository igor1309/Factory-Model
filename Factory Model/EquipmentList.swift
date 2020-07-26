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
    
//    @ObservedObject
    var factory: Factory
    
    init(at factory: Factory) {
        self.factory = factory
        _equipments = FetchRequest(
            entity: Equipment.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Equipment.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Equipment.factory), factory
            )
        )
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
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let equipment = Equipment(context: moc)
            equipment.name = "New Equipment"
            equipment.lifetime = 7
            equipment.price = 1_000_000
            factory.addToEquipments_(equipment)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeEquipment(at offsets: IndexSet) {
        for index in offsets {
            let expense = equipments[index]
            moc.delete(expense)
        }
        
        moc.saveContext()
    }
}

//struct EquipmentList_Previews: PreviewProvider {
//    static var previews: some View {
//        EquipmentList()
//    }
//}
