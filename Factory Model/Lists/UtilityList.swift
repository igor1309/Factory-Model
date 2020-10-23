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
    
    let period: Period
    
    init(for base: Base, in period: Period) {
        self.base = base
        self.period = period
    }
    
    var body: some View {
        ListWithDashboard(
            for: base,
            predicate: NSPredicate(format: "%K == %@", #keyPath(Utility.base), base),
            in: period
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
                    LabelWithDetail("Utility Total, ex VAT", base.utilitiesExVAT(in: period).formattedGrouped)
                    LabelWithDetail("Utility Total, incl VAT", base.utilitiesWithVAT(in: period).formattedGrouped)
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)
            }
        } editor: { (utility: Utility) in
            UtilityEditor(utility, in: period)
        }
    }
}

struct UtilityList_Previews: PreviewProvider {
    static let period: Period = .month()
    
    static var previews: some View {
        NavigationView {
            UtilityList(for: PersistenceManager.basePreview, in: period)
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, PersistenceManager.preview)
        }
    }
}
