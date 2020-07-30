//
//  AllFeedstockList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 22.07.2020.
//

import SwiftUI

struct AllFeedstockList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Feedstock.factory), factory
            )
        ) {
            CreateChildButton(
                systemName: "plus.square",
                childType: Feedstock.self,
                parent: factory,
                keyPath: \Factory.feedstocks_
            )
        } dashboard: {
            Text("TBD: dashboard")
                .font(.subheadline)
        } editor: { (feedstock: Feedstock) in
            FeedstockView(feedstock)
        }
    }
}
