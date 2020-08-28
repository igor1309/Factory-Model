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
            predicate: Packaging.factoryPredicate(for: factory)
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
//            Text("TBD: dashboard: List of packaging types (??)")
//                .font(.subheadline)
//                .foregroundColor(.systemRed)
        } editor: { (packaging: Packaging) in
            PackagingEditor(packaging, in: period)
        }
    }
}
