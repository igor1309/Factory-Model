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
                LabelWithDetail("scalemass", "Production Weight Netto, t", factory.produced(in: period).weightNettoStr)
                                
                LabelWithDetail("dollarsign.circle", "Production Cost ex VAT", factory.productionCost(in: period).costExVATStr)
                
                LabelWithDetail(
                    "dollarsign.circle",
                    "Avg Cost ex VAT, per kilo",
                    //factory.avgCostPerKiloExVAT(in: period).formattedGrouped
                    factory.sold(in: period).perKilo.costStr
                )
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section(
            header: Text("Sales")
        ) {
            Group {
                LabelWithDetail("scalemass", "Sales Weight Netto, t", factory.sold(in: period).weightNettoStr)
                
                LabelWithDetail(Sales.icon, "Revenue ex VAT", factory.revenueExVAT(in: period).formattedGrouped)
                
                LabelWithDetail(
                    "dollarsign.circle",
                    "Avg Price ex VAT, per kilo",
                    //factory.avgPricePerKiloExVAT(in: period).formattedGrouped
                    factory.sold(in: period).perKilo.priceStr
                )
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section(
            header: Text("Margin")
        ) {
            Group {
                LabelWithDetail(Sales.icon, "Margin ex VAT", factory.pnl(in: period).margin.formattedGrouped)
                
                LabelWithDetail(
                    Sales.icon,
                    "Avg Margin ex VAT, per kilo",
                    //factory.avgMarginPerKiloExVAT(in: period).formattedGrouped
                    factory.sold(in: period).perKilo.marginStr
                )
            }
            .foregroundColor(factory.sold(in: period).perKilo.margin > 0 ? .secondary : .red)
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
