//
//  AllBuyersList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct AllBuyersList: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    @ViewBuilder
    private func dashboard() -> some View {}
    
    var body: some View {
        FactoryChildrenListWithDashboard(for: factory,title: "All Buyers", predicate: nil, dashboard: dashboard) { (buyer: Buyer) in
            BuyerEditor(buyer)
        }
    }
}

struct AllBuyersList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllBuyersList(for: Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
