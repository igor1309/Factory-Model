//
//  AllBuyersList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct AllBuyersList: View {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            title: "All Buyers",
            parent: factory,
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Buyer.factory), factory
            )
        ) {
            CreateChildButton(
                systemName: "cart.badge.plus",
                childType: Buyer.self, parent: factory,
                keyPath: \Factory.buyers_
            )
        } dashboard: {
            
        } editor: { (buyer: Buyer) in
            BuyerEditor(buyer)
        }
        
    }
}
