//
//  UtilityList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct UtilityList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var utilities: FetchedResults<Utility>
    
    var base: Base
    
    init(for base: Base, predicate: NSPredicate? = nil) {
        self.base = base
        _utilities = Utility.defaultFetchRequest(with: predicate)
    }
    
    var body: some View {
        ListWithDashboard(
            parent: base,
            keyPath: \Base.utilities_,
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
                    LabelWithDetail("Utility Total, ex VAT", base.totalUtilitiesExVAT.formattedGrouped)
                    LabelWithDetail("Utility Total, incl VAT", base.totalUtilitiesWithVAT.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        } editor: { (utility: Utility) in
            UtilityView(utility)
        }
    }
}
