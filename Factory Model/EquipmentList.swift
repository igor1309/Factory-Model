//
//  EquipmentList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EquipmentList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var equipment: FetchedResults<Equipment>
    
    var factory: Factory
    
    init(at factory: Factory) {
        self.factory = factory
        _equipment = FetchRequest(
            entity: Equipment.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Equipment.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@", factory
            )
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                Group {
                    LabelWithDetail("Equipment Total", factory.equipmentTotal.formattedGroupedWith1Decimal)
                    LabelWithDetail("Amortization, monthly", factory.amortizationMonthly.formattedGroupedWith1Decimal)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(header: Text("Equipment")) {
                ForEach(equipment, id: \.self) { equipment in
                    NavigationLink(
                        destination: EquipmentView(equipment: equipment, for: factory)
                    ) {
                        ListRow(
                            title: equipment.name,
                            subtitle: "\(equipment.price) for \(equipment.lifetime) years",
                            detail: "\(equipment.note)",
                            icon: "wrench.and.screwdriver",
                            useSmallerFont: true
                        )
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
            let equipment = Equipment(context: managedObjectContext)
            equipment.name = "New Equipment"
            //            equipment.note = "Some note regarding new equipment"
            equipment.lifetime = 7
            equipment.price = 1_000_000
            factory.addToEquipments_(equipment)
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeEquipment(at offsets: IndexSet) {
        for index in offsets {
            let expense = equipment[index]
            managedObjectContext.delete(expense)
        }
        
        managedObjectContext.saveContext()
    }
}

//struct EquipmentList_Previews: PreviewProvider {
//    static var previews: some View {
//        EquipmentList()
//    }
//}
