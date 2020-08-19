//
//  UtilityList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct UtilityList: View {
    @Environment(\.managedObjectContext) private var moc
    
    var base: Base
    
    init(for base: Base) {
        self.base = base
    }
    
    var body: some View {
        ListWithDashboard(
            for: base,
            predicate: NSPredicate(format: "%K == %@", #keyPath(Utility.base), base)
        ) {
            CreateChildButton(
                systemName: "gauge.badge.plus",
                childType: Utility.self,
                parent: base,
                keyPath: \Base.utilities_
            )
        } dashboard: {
            Section(
                header: Text("Total")
            ) {
                Group {
                    LabelWithDetail("Utility Total, ex VAT", base.utilitiesExVAT.formattedGrouped)
                    LabelWithDetail("Utility Total, incl VAT", base.utilitiesWithVAT.formattedGrouped)
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)
            }
        } editor: { (utility: Utility) in
            UtilityEditor(utility)
        }
    }
}
