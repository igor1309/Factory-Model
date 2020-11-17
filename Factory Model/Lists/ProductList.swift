//
//  ProductList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 24.07.2020.
//

import SwiftUI

struct ProductList: View {
    
    @EnvironmentObject private var settings: Settings
    
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
        CreateNewEntityButton<Product>()
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        Section(header: Text("Production")) {
            productionGroup()
                .foregroundColor(.secondary)
        }
        
        Section(header: Text("Sales")) {
            salesGroup()
                .foregroundColor(.secondary)
        }
        
        Section(header: Text("Margin")) {
            marginGroup()
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
    
    @ViewBuilder
    private func productionGroup() -> some View {
        if settings.asStack {
            /// no icons
            VStack(spacing: 6) {
                LabelWithDetail("Production Weight Netto, t", factory.produced(in: settings.period).weightNettoTonsStr)
                
                LabelWithDetail("Production Cost ex VAT", factory.produced(in: settings.period).cost.fullCostStr)
                
                LabelWithDetail(
                    "Avg Cost ex VAT, per kilo",
                    //factory.avgCostPerKiloExVAT(in: settings.period).formattedGrouped
                    factory.perKilo(in: settings.period).cost.fullCostStr
                )
            }
            .padding(.vertical, 3)
            .font(.footnote)
        } else {
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
            .font(.subheadline)
        }
    }
    
    @ViewBuilder
    private func salesGroup() -> some View {
        if settings.asStack {
            /// no icons
            VStack(spacing: 6) {
                LabelWithDetail("Sales Weight Netto, t", factory.sold(in: settings.period).weightNettoTonsStr)
                
                LabelWithDetail("Revenue ex VAT", factory.revenueExVAT(in: settings.period).formattedGrouped)
                
                LabelWithDetail(
                    "Avg Price ex VAT, per kilo",
                    //factory.avgPricePerKiloExVAT(in: settings.period).formattedGrouped
                    factory.perKilo(in: settings.period).priceStr
                )
            }
            .padding(.vertical, 3)
            .font(.footnote)
        } else {
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
            .font(.subheadline)
        }
    }
    
    @ViewBuilder
    private func marginGroup() -> some View {
        if settings.asStack {
            /// no icons
            VStack(spacing: 6) {
                LabelWithDetail("Margin ex VAT", factory.pnl(in: settings.period).margin.formattedGrouped)
                
                LabelWithDetail(
                    "Avg Margin ex VAT, per kilo",
                    //factory.avgMarginPerKiloExVAT(in: settings.period).formattedGrouped
                    factory.perKilo(in: settings.period).marginStr
                )
            }
            .foregroundColor(factory.perKilo(in: settings.period).margin > 0 ? .secondary : .red)
            .padding(.vertical, 3)
            .font(.footnote)
        } else {
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
    }
}

struct ProductList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductList(for: Factory.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 1000))
    }
}
