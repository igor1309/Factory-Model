//
//  BuyerList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct BuyerList: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        EntityListWithDashboard(for: factory, keyPathToParent: \Buyer.factory, dashboard: dashboard)
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        Text("TBD: Dashboard")
            .foregroundColor(.secondary)
    }
}

struct BuyerList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BuyerList(for: Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
