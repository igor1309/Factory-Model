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
        
        SectionAsStackOrGroup(header: "Production", labelGroup: productionGroup(), asStack: settings.asStack)
        
        SectionAsStackOrGroup(header: "Sales", labelGroup: salesGroup(), asStack: settings.asStack)
        
        SectionAsStackOrGroup(header: "Margin", labelGroup: marginGroup(), asStack: settings.asStack)
        
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
    
    private func productionGroup() -> some View {
        Group {
            LabelWithDetail(
                settings.asStack ? nil : "scalemass",
                "Production Weight Netto, t",
                factory.produced(in: settings.period).weightNettoTonsStr
            )
            
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.circle",
                "Production Cost ex VAT",
                factory.produced(in: settings.period).cost.fullCostStr
            )
            
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.circle",
                "Avg Cost ex VAT, per kilo",
                //factory.avgCostPerKiloExVAT(in: settings.period).formattedGrouped
                factory.perKilo(in: settings.period).cost.fullCostStr
            )
        }
    }
    
    private func salesGroup() -> some View {
        Group {
            LabelWithDetail(
                settings.asStack ? nil : "scalemass",
                "Sales Weight Netto, t",
                factory.sold(in: settings.period).weightNettoTonsStr
            )
            
            LabelWithDetail(
                settings.asStack ? nil : Sales.icon,
                "Revenue ex VAT",
                factory.revenueExVAT(in: settings.period).formattedGrouped
            )
            
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.circle",
                "Avg Price ex VAT, per kilo",
                //factory.avgPricePerKiloExVAT(in: settings.period).formattedGrouped
                factory.perKilo(in: settings.period).priceStr
            )
        }
    }
    
    private func marginGroup() -> some View {
        Group {
            LabelWithDetail(
                settings.asStack ? nil : Sales.icon,
                "Margin ex VAT",
                factory.pnl(in: settings.period).margin.formattedGrouped
            )
            
            LabelWithDetail(
                settings.asStack ? nil : Sales.icon,
                "Avg Margin ex VAT, per kilo",
                //factory.avgMarginPerKiloExVAT(in: settings.period).formattedGrouped
                factory.perKilo(in: settings.period).marginStr
            )
        }
        .foregroundColor(factory.perKilo(in: settings.period).margin > 0 ? .secondary : .red)
    }
}

struct ProductList_Previews: PreviewProvider {
    static var settings1 = Settings()
    static var settings2 = Settings()
    
    static var previews: some View {
        settings1.asStack = true
        settings2.asStack = false
        
        return Group {
            NavigationView {
                ProductList(for: Factory.example)
            }
            .previewLayout(.fixed(width: 350, height: 900))
            .environmentObject(settings1)
            
            NavigationView {
                ProductList(for: Factory.example)
            }
            .previewLayout(.fixed(width: 350, height: 900))
            .environmentObject(settings2)
        }
        .preferredColorScheme(.dark)
    }
}
