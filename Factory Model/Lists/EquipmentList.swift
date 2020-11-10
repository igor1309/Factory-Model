//
//  EquipmentList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EquipmentList: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
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
    }
    
    var body: some View {
        EntityListWithDashboard(for: factory, keyPathToParent: \Equipment.factory, dashboard: dashboard) { (equipment: Equipment) in
            EquipmentEditor(equipment)
        }
    }
}

struct EquipmentList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EquipmentList(for: Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
