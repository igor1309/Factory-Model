//
//  EquipmentRow.swift
//  Factory Model
//
//  Created by Igor Malyarov on 23.07.2020.
//

import SwiftUI

struct EquipmentRow: View {
    @ObservedObject var equipment: Equipment
    let useSmallerFont: Bool
    
    init(
        _ equipment: Equipment,
        useSmallerFont: Bool = true
    ) {
        self.equipment = equipment
        self.useSmallerFont = useSmallerFont
    }
    
    var body: some View {
        ListRow(
            title: equipment.name,
            subtitle: equipment.note,
            detail: equipment.idd,
            icon: "wrench.and.screwdriver",
            useSmallerFont: useSmallerFont
        )
    }
}
