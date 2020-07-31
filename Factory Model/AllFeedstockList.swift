//
//  AllFeedstockList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI
import CoreData

struct AllFeedstockList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            predicate: Feedstock.factoryPredicate(for: factory)
        ) {
            //  MARK: - FINISH THIS FUGURE OUT HOW TO CREATE ENTITY HERE
            EmptyView()
           /* CreateChildButton(
                systemName: "plus.square",
                childType: Feedstock.self,
                parent: factory,
                keyPath: \Factory.feedstocks_
            ) */
        } dashboard: {
            Text("TBD: dashboard")
                .font(.subheadline)
        } editor: { (feedstock: Feedstock) in
            FeedstockView(feedstock)
        }
    }
}
