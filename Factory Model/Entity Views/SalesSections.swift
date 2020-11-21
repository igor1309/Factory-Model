//
//  SalesSections.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import SwiftUI

struct SalesSections: View {
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(
            header: Text("Sales")
        ) {
            VStack(alignment: .leading, spacing: 9) {
                DataPointsView(dataBlock: factory.revenueDataPoints(in: settings.period, title: "Products"))
                    .foregroundColor(Product.color)
                
                DataPointsView(dataBlock: factory.basesRevenueDataPoints(in: settings.period, title: "Base Products"))
                    .foregroundColor(Base.color)
            }
            .padding(.vertical, 3)
            
            
            Group {
                NavigationLink(
                    destination: SalesList(for: factory)
                ) {
                    LabelWithDetail(Sales.icon, "Revenue, ex VAT", factory.revenueExVAT(in: settings.period).formattedGrouped)
                }
                .foregroundColor(Sales.color)
                
                NavigationLink(
                    destination: BuyerList(for: factory)
                ) {
                    LabelWithDetail(Buyer.icon, "All Buyers", "")
                }
                .foregroundColor(Buyer.color)
            }
            .font(.subheadline)
        }
        
        
        CostSection<EmptyView>(factory.sold(in: settings.period).cost)
    }
}

struct SalesSections_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                SalesSections(for: Factory.example)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Test Factory", displayMode: .inline)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 600))
    }
}
