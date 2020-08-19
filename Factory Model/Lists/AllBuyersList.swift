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
            predicate: nil// if nil use default!!
        ) {
            
        } editor: { (buyer: Buyer) in
            BuyerEditor(buyer)
        }
    }
}
