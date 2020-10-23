//
//  PackagingList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingList: View {
    @ObservedObject var factory: Factory
    
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        ListWithDashboard(
            for: factory,
            predicate: Packaging.factoryPredicate(for: factory),
            in: period
        ) {
            //  MARK: - FINISH THIS FIGURE OUT HIW TO CREATE PACKAGING FROM HERE
            EmptyView()
           /* CreateChildButton(
                systemName: "plus.square",
                childType: Packaging.self,
                parent: factory,
                keyPath: \Factory.packagings_
            ) */
        } dashboard: {
            Section {
                Group {
                    LabelWithDetail("squareshape.split.3x3", "No of Packagings", factory.packagings.count.formattedGrouped)
//                    LabelWithDetail(<#T##systemName: String##String#>, <#T##title: _##_#>, <#T##detail: _##_#>)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
//            Text("TBD: dashboard: List of packaging types (??)")
//                .font(.subheadline)
//                .foregroundColor(.systemRed)
        } editor: { (packaging: Packaging) in
            PackagingEditor(packaging, in: period)
        }
    }
}

struct PackagingList_Previews: PreviewProvider {
    static let period: Period = .month()
    
    static var previews: some View {
        NavigationView {
            PackagingList(for: PersistenceManager.factoryPreview, in: period)
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, PersistenceManager.preview)
        }
    }
}
