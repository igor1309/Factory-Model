//
//  ProductList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductList: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ListWithDashboard(
            childType: Product.self,
            predicate: Product.factoryPredicate(for: factory),
            plusButton: plusButton,
            dashboard: dashboard
        )
    }
    
    private func plusButton() -> some View {
        CreateNewEntityBarButton<Product>()
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        Section(
            header: Text("Production")
        ) {
            Group {
                LabelWithDetail("scalemass", "Production Weight Netto, t", factory.produced(in: settings.period).weightNettoTonsStr)
                
                LabelWithDetail("dollarsign.circle", "Production Cost ex VAT", factory.produced(in: settings.period).cost.fullCostStr)
                
                LabelWithDetail(
                    "dollarsign.circle",
                    "Avg Cost ex VAT, per kilo",
                    //factory.avgCostPerKiloExVAT(in: settings.period).formattedGrouped
                    factory.perKilo(in: settings.period).cost.fullCostStr
                )
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section(
            header: Text("Sales")
        ) {
            Group {
                LabelWithDetail("scalemass", "Sales Weight Netto, t", factory.sold(in: settings.period).weightNettoTonsStr)
                
                LabelWithDetail(Sales.icon, "Revenue ex VAT", factory.revenueExVAT(in: settings.period).formattedGrouped)
                
                LabelWithDetail(
                    "dollarsign.circle",
                    "Avg Price ex VAT, per kilo",
                    //factory.avgPricePerKiloExVAT(in: settings.period).formattedGrouped
                    factory.perKilo(in: settings.period).priceStr
                )
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section(
            header: Text("Margin")
        ) {
            Group {
                LabelWithDetail(Sales.icon, "Margin ex VAT", factory.pnl(in: settings.period).margin.formattedGrouped)
                
                LabelWithDetail(
                    Sales.icon,
                    "Avg Margin ex VAT, per kilo",
                    //factory.avgMarginPerKiloExVAT(in: settings.period).formattedGrouped
                    factory.perKilo(in: settings.period).marginStr
                )
            }
            .foregroundColor(factory.perKilo(in: settings.period).margin > 0 ? .secondary : .red)
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

struct ProductList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductList(for: Factory.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 350, height: 1100))
    }
}
