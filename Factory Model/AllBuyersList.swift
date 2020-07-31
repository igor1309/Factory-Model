//
//  AllBuyersList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct AllBuyersList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        EntityListWithDashboard(
            for: factory,
            title: "All Buyers",
            predicate: nil,// if nil use default!!
            keyPathParentToChildren: \Factory.buyers_
        ) {
            
        } editor: { (buyer: Buyer) in
            BuyerView(buyer)
        }
        
    }
    
    var old: some View {
        ListWithDashboard(
            title: "All Buyers",
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Buyer.factory), factory
            )
        ) {
            CreateChildButton(
                systemName: "cart.badge.plus",
                childType: Buyer.self,
                parent: factory,
                keyPath: \Factory.buyers_
            )
        } dashboard: {
            
        } editor: { (buyer: Buyer) in
            BuyerView(buyer)
        }
    }
}
