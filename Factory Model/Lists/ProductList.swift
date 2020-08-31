//
//  ProductList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductList: View {
    @ObservedObject var factory: Factory
    
    let period: Period
    
    init(for factory: Factory, in period: Period){
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        ListWithDashboard(
            for: factory,
            predicate: Product.factoryPredicate(for: factory),
            in: period
        ) {
            CreateOrphanButton<Product>(systemName: Product.plusButtonIcon)
        } dashboard: {
            dashboard
        } editor: { (product: Product) in
            ProductView(product, in: period)
        }
        
    }
    
    @ViewBuilder
    private var dashboard: some View {
        Section(
            header: Text("Production")
        ) {
            Group {
                LabelWithDetail("scalemass", "Production Weight Netto, t", factory.productionWeightNetto(in: period).formattedGroupedWith1Decimal)
                                
                LabelWithDetail("dollarsign.circle", "Production Cost ex VAT", factory.productionCostExVAT(in: period).formattedGrouped)
                
                LabelWithDetail("dollarsign.circle", "Avg Cost ex VAT, per kilo", factory.avgCostPerKiloExVAT(in: period).formattedGrouped)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section(
            header: Text("Sales")
        ) {
            Group {
                LabelWithDetail("scalemass", "Sales Weight Netto, t", factory.salesWeightNetto(in: period).formattedGroupedWith1Decimal)
                
                LabelWithDetail(Sales.icon, "Revenue ex VAT", factory.revenueExVAT(in: period).formattedGrouped)
                
                LabelWithDetail("dollarsign.circle", "Avg Price ex VAT, per kilo", factory.avgPricePerKiloExVAT(in: period).formattedGrouped)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section(
            header: Text("Margin")
        ) {
            Group {
                LabelWithDetail(Sales.icon, "Margin ex VAT", factory.margin(in: period).formattedGrouped)
                
                LabelWithDetail(Sales.icon, "Avg Margin ex VAT, per kilo", factory.avgMarginPerKiloExVAT(in: period).formattedGrouped)
            }
            .foregroundColor(factory.avgMarginPerKiloExVAT(in: period) > 0 ? .secondary : .red)
            .font(.subheadline)
        }
        
        Section(
            header: Text("TBD Total"),
            footer: Text("Go to Base to create New Product")
        ) {
            Group {
                NavigationLink(
                    destination: Text("TBD")
                ) {
                    ListRow(
                        title: "TBD Производство и продажи",
                        subtitle: "TBD Общие выручка и затраты, средние цены продаж, маржа",
                        detail: "TBD тут ли это показывать???",
                        icon: "cart"
                    )
                }
                
                NavigationLink(
                    destination: Text("TBD")
                ) {
                    ListRow(
                        title: "TBD Агрегированные данные по группам (Product Type)",
                        subtitle: "TBD Выручка и затраты, средние цены продаж, маржа",
                        detail: "TBD тут ли это показывать???",
                        icon: "cart"
                    )
                }
            }
            .font(.subheadline)
        }
    }
}
