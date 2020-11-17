//
//  UtilityList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct UtilityList: View {
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var base: Base
    
    init(for base: Base) {
        self.base = base
        self.predicate = NSPredicate(format: "%K == %@", #keyPath(Utility.base), base)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            childType: Utility.self,
            predicate: predicate,
            plusButton: plusButton,
            dashboard: dashboard
        )
    }
    
    private func plusButton() -> some View {
        CreateChildButton(parent: base, keyPathToParent: \Utility.base)
    }
    
    private func dashboard() -> some View {
        Section(
            header: Text("Total")
        ) {
            Group {
                LabelWithDetail("Utility Total, ex VAT", base.utilitiesExVAT(in: settings.period).formattedGrouped)
                LabelWithDetail("Utility Total, incl VAT", base.utilitiesWithVAT(in: settings.period).formattedGrouped)
                    .foregroundColor(.secondary)
            }
            .font(.subheadline)
        }
    }
}

struct UtilityList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UtilityList(for: Base.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
