//
//  EquipmentList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EquipmentList: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            parent: factory,
            pathFromParent: "equipments_",
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
        } editor: { equipment in
            EquipmentView(equipment)
        }
    }
}
