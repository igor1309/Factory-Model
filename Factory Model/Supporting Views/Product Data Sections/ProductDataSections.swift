//
//  ProductDataView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.08.2020.
//

import SwiftUI
import CoreData

struct ProductDataSections<T: NSManagedObject & Inventorable & Merch>: View {
    
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var entity: T
    
    init(_ entity: T) {
        self.entity = entity
    }
    var body: some View {
        
        SectionAsStackOrGroup(header: "Price & Margin", labelGroup: groupPriceAndMargin(), asStack: settings.asStack)
        
        SectionAsStackOrGroup(header: "Sales", labelGroup: salesGroup(), asStack: settings.asStack)
        
        SectionAsStackOrGroup(header: "Production", labelGroup: groupProduction(), asStack: settings.asStack)
        
        Text("Base Products Production Quantity is calculated using Products Production.")
            .foregroundColor(.secondary)
            .font(.caption)
        
        Section(
            header: Text("Inventory")
        ) {
            Group {
                // AmountPicker(systemName: "building.2", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $entity.initialInventory)
                
                LabelWithDetail(
                    "building.2",
                    "Closing Inventory",
                    entity.closingInventory(in: settings.period).formattedGrouped
                )
                .foregroundColor(entity.closingInventory(in: settings.period) < 0 ? .systemRed : .secondary)
            }
            .font(.subheadline)
        }
    }
    
    private func groupPriceAndMargin() -> some View {
        Group {
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.circle",
                "Average Price, ex VAT",
                entity.perKilo(in: settings.period).priceStr
            )
            
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.square",
                "Margin",
                //entity.margin(in: settings.period).formattedGroupedWith1Decimal
                entity.perKilo(in: settings.period).marginStr
            )
            .foregroundColor(entity.perKilo(in: settings.period).margin > 0 ? .systemGreen : .systemRed)
            
            LabelWithDetail(
                settings.asStack ? nil : "percent",
                "Margin, percentage",
                //entity.marginPercentage(in: settings.period).formattedPercentage
                entity.perKilo(in: settings.period).marginPercentageStr
            )
            .foregroundColor(entity.perKilo(in: settings.period).marginPercentage > 0 ? .systemGreen : .systemRed)
        }
    }
    
    @ViewBuilder
    private func salesGroup() -> some View {
        Group {
            LabelWithDetail(
                settings.asStack ? nil : "square",
                "Qty",
                // entity.salesQty(in: settings.period).formattedGrouped
                entity.salesQty(in: settings.period).formattedGrouped
            )
            
            LabelWithDetail(
                settings.asStack ? nil : "scalemass",
                "Weight Netto, t",
                //entity.salesWeightNettoTons(in: settings.period).formattedGroupedWith1Decimal
                entity.sold(in: settings.period).weightNettoTonsStr
            )
        }
        .foregroundColor(.secondary)
        
        if settings.asStack { Divider() }
        
        Group {
            LabelWithDetail(
                settings.asStack ? nil : Sales.icon,
                "Revenue, ex VAT",
                //entity.revenueExVAT(in: settings.period).formattedGrouped
                entity.sold(in: settings.period).priceStr
            )
            .foregroundColor(.systemGreen)
            
            //                    LabelWithDetail(
            //                        Sales.icon,
            //                        "Revenue, with VAT",
            //                        entity.revenueWithVAT(in: settings.period).formattedGrouped
            //                    )
            //                    .foregroundColor(.secondary)
            
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.square",
                "COGS",
                //entity.cogs(in: settings.period).formattedGrouped
                entity.sold(in: settings.period).cost.fullCostStr
            )
            
            if settings.asStack { Divider() }
            
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.square",
                "Margin",
                //entity.totalMargin(in: settings.period).formattedGrouped
                entity.sold(in: settings.period).marginStr
            )
            .foregroundColor(entity.sold(in: settings.period).margin > 0 ? .systemGreen : .systemRed)
            
            LabelWithDetail(
                settings.asStack ? nil : "percent",
                "Margin, percentage",
                //entity.marginPercentage(in: settings.period).formattedPercentage
                entity.sold(in: settings.period).marginPercentageStr
            )
            .foregroundColor(entity.sold(in: settings.period).marginPercentage > 0 ? .systemGreen : .systemRed)
        }
    }
    
    private func groupProduction() -> some View {
        Group {
            if entity.closingInventory(in: settings.period) < 0 {
                Text("Negative Closing Inventory - check Production and Sales Qty of Products!")
                    .foregroundColor(.systemRed)
                
                if settings.asStack { Divider() }
            }
            
            LabelWithDetail(
                settings.asStack ? nil : "wrench.and.screwdriver",
                "Qty",
                //entity.productionQty(in: settings.period).formattedGrouped
                entity.productionQty(in: settings.period).formattedGrouped
            )
            
            LabelWithDetail(
                settings.asStack ? nil : "scalemass",
                "Weight Netto, t",
                //entity.productionWeightNettoTons(in: settings.period).formattedGroupedWith1Decimal
                entity.produced(in: settings.period).weightNettoTonsStr
            )
            .foregroundColor(.systemRed)
            
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.square",
                "Cost",
                //entity.productionCostExVAT(in: settings.period).formattedGrouped
                entity.produced(in: settings.period).cost.fullCostStr
            )
        }
    }
}

struct ProductDataSections_Previews: PreviewProvider {
    static var settings1 = Settings()
    static var settings2 = Settings()
    
    static var previews: some View {
        settings1.asStack = true
        settings2.asStack = false
        
        return Group {
            NavigationView {
                List {
                    ProductDataSections(Base.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("ProductDataSections", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 800))
            .environmentObject(settings1)
            
            NavigationView {
                List {
                    ProductDataSections(Base.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("ProductDataSections", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 1000))
            .environmentObject(settings2)
        }
        .environment(\.colorScheme, .dark)
    }
}
