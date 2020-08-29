//
//  EquipmentList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EquipmentList: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var factory: Factory
    
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        EntityListWithDashboard(for: factory, in: period) {
            Section(header: Text("Total")) {
                Group {
                    LabelWithDetail("wrench.and.screwdriver", "Salvage Value", "TBD")
                        .foregroundColor(.primary)
                    
                    /// https://www.investopedia.com/terms/a/accumulated-depreciation.asp
                    LabelWithDetail("wrench.and.screwdriver", "Accumulated Depreciation", "TBD")
                    
                    LabelWithDetail("wrench.and.screwdriver", "Cost basis", factory.equipmentTotal.formattedGrouped)
                    
                    LabelWithDetail("dollarsign.circle", "Depreciation, monthly", factory.depreciationMonthly.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        } editor: { (equipment: Equipment) in
//            EquipmentView(equipment)
            EquipmentEditor(equipment, in: period)
        }
    }
}
