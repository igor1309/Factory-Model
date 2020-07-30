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
            parent: factory,
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Packaging.factory), factory
            )
        ) {
            CreateChildButton(
                systemName: "plus.square",
                childType: Packaging.self,
                parent: factory,
                keyPath: \Factory.packagings_
            )
        } dashboard: {
            Text("TBD: dashboard")
                .font(.subheadline)
        } editor: { (packaging: Packaging) in
            PackagingView(packaging)
        }
    }
}
