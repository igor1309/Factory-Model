//
//  SalesSections.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import SwiftUI

struct SalesSections: View {
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(
            header: Text("Sales")
        ) {
            //  MARK: Money
            //
            VStack(alignment: .leading, spacing: 6) {
                Text("Money".uppercased())
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                DataPointsView(dataBlock: factory.revenueDataPoints(in: settings.period, title: "Products"))
                    .foregroundColor(Product.color)
                
                DataPointsView(dataBlock: factory.basesRevenueDataPoints(in: settings.period, title: "Base Products"))
                    .foregroundColor(Base.color)
            }
            .padding(.vertical, 3)
            
            
            //  MARK: Volumes
            //
            VStack(alignment: .leading, spacing: 6) {
                Text("TBD: change sample data to real")
                    .foregroundColor(.systemRed)
                    .font(.footnote)
                
                Text("Volume".uppercased())
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                DataPointsView(dataBlock: factory.revenueDataPoints(in: settings.period, title: "Products"))
                    .foregroundColor(Product.color)
                
                DataPointsView(dataBlock: factory.basesRevenueDataPoints(in: settings.period, title: "Base Products"))
                    .foregroundColor(Base.color)
            }
            .padding(.vertical, 3)
            
            
            //  MARK: Links
            //
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
        .previewLayout(.fixed(width: 350, height: 820))
    }
}
