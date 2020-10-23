//
//  AllBuyersList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct AllBuyersList: View {
    @ObservedObject var factory: Factory
    
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        EntityListWithDashboard(
            for: factory,
            title: "All Buyers",
            in: period,
            predicate: nil
        ) {
            
        } editor: { (buyer: Buyer) in
            BuyerEditor(buyer, in: period)
        }
    }
}

struct AllBuyersList_Previews: PreviewProvider {
    static let period: Period = .month()
    
    static var previews: some View {
        NavigationView {
            AllBuyersList(for: PersistenceManager.factoryPreview, in: period)
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, PersistenceManager.preview)
        }
    }
}
