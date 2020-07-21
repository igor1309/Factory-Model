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
            Section(header: Text("Equipment Total".uppercased())) {
                Group {
                    HStack {
                        Text("Equipment Total")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(factory.equipmentTotal, specifier: "%.f")")
                    }
                    HStack {
                        Text("Amortization, monthly")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(factory.amortizationMonthly, specifier: "%.f")")
                    }
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Equipment".uppercased())) {
                ForEach(equipment, id: \.self) { equipment in
                    NavigationLink(
                        destination: EquipmentView(equipment: equipment, for: factory)
                    ) {
                        ListRow(title: equipment.name,
                                subtitle: "\(equipment.price) for \(equipment.lifetime) years",
                                detail: "\(equipment.note)",
                                icon: "wrench.and.screwdriver")
                    }
                }
                .onDelete(perform: removeEquipment)
                
                Button("Add Equipment") {
                    let equipment = Equipment(context: managedObjectContext)
                    equipment.name = "New Equipment"
                    equipment.note = "Some note regarding new equipment"
                    equipment.lifetime = 7
                    equipment.price = 1_000_000
                    factory.addToEquipment_(equipment)
                    save()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(factory.name)
    }
    
    private func removeEquipment(at offsets: IndexSet) {
        for index in offsets {
            let expense = equipment[index]
            managedObjectContext.delete(expense)
        }
        
        save()
    }
    
    private func save() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // handle the Core Data error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//struct EquipmentList_Previews: PreviewProvider {
//    static var previews: some View {
//        EquipmentList()
//    }
//}
