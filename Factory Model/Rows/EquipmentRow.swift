//
//  EquipmentRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI

struct EquipmentRow: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        
        let equipmentList = ListWithDashboard(
            title: "Equipment",
            parent: factory,
            path: "equipments_",
            keyPath: \Equipment.factory!,
            predicate: Equipment.factoryPredicate(for: factory),
            useSmallerFont: true
        ) {
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
        } editor: {
            EquipmentView($0)
        }
        
        Group {
            NavigationLink(
                destination: equipmentList
            ) {
                //  MARK: more clever depreciation?
                LabelWithDetail("wrench.and.screwdriver", "Salvage Value", "TBD")
            }
            
            LabelWithDetail("wrench.and.screwdriver", "Cost basis", "TBD")
                .foregroundColor(.secondary)
                .padding(.trailing)
        }
        .foregroundColor(.systemTeal)
        .font(.subheadline)
        .padding(.vertical, 3)
    }
}
