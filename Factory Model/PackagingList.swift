//
//  PackagingList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI

struct PackagingList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            predicate: NSPredicate(
                format: "ANY %K.base.factory == %@", #keyPath(Packaging.products_), factory
            )
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
            PackagingView(packaging)
        }
    }
}
