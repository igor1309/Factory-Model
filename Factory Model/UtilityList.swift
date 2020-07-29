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
        List {
            Section(header: Text("Total")) {
                Group {
                    LabelWithDetail("Utility Total, ex VAT", base.totalUtilitiesExVAT.formattedGrouped)
                    LabelWithDetail("Utility Total, incl VAT", base.totalUtilitiesWithVAT.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            GenericListSection(
                type: Utility.self,
                //  MARK: - FINISH THIS WITH DEFAULT PREDICATE
                predicate: NSPredicate(format: "%K == %@", "base", base)
            ) { (utility: Utility) in
                UtilityView(utility)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(trailing: plusButton)
        .navigationBarItems(trailing: CreateChildButton(systemName: "gauge.badge.plus", childType: Utility.self, parent: base, keyPath: \Base.utilities_))
    }
    
    
    private func removeUtility(at offsets: IndexSet) {
        for index in offsets {
            let util = utilities[index]
            moc.delete(util)
        }
        moc.saveContext()
    }
}
