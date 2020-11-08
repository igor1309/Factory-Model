//
//  ProductDataView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.08.2020.
//

import SwiftUI
import CoreData

struct ProductDataSections<T: NSManagedObject & Inventorable & Merch>: View {
    
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var entity: T
    
    init(_ entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        
        Section {
            VStack(spacing: 8) {
                Group {
                    LabelWithDetail(
                        "dollarsign.circle",
                        "Average Price, ex VAT",
                        entity.perKilo(in: settings.period).priceStr
                    )
                    
                    LabelWithDetail(
                        "dollarsign.square",
                        "Margin",
                        //entity.margin(in: settings.period).formattedGroupedWith1Decimal
                        entity.perKilo(in: settings.period).marginStr
                    )
                    .foregroundColor(entity.perKilo(in: settings.period).margin > 0 ? .systemGreen : .systemRed)
                    
                    LabelWithDetail(
                        "percent",
                        "Margin, percentage",
                        //entity.marginPercentage(in: settings.period).formattedPercentage
                        entity.perKilo(in: settings.period).marginPercentageStr
                    )
                    .foregroundColor(entity.perKilo(in: settings.period).marginPercentage > 0 ? .systemGreen : .systemRed)
                }
            }
            .font(.subheadline)
            .padding(.vertical, 4)
        }
        
        Section(
            header: Text("Sales")
        ) {
            VStack(spacing: 8) {
                Group {
                    LabelWithDetail(
                        "square",
                        "Qty",
                        // entity.salesQty(in: settings.period).formattedGrouped
                        entity.salesQty(in: settings.period).formattedGrouped
                    )
                    
                    LabelWithDetail(
                        "scalemass",
                        "Weight Netto, t",
                        //entity.salesWeightNettoTons(in: settings.period).formattedGroupedWith1Decimal
                        entity.sold(in: settings.period).weightNettoTonsStr
                    )
                }
                .foregroundColor(.secondary)
                
                Divider()
                
                Group {
                    
                    LabelWithDetail(
                        Sales.icon,
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
                        "dollarsign.square",
                        "COGS",
                        //entity.cogs(in: settings.period).formattedGrouped
                        entity.sold(in: settings.period).cost.fullCostStr
                    )
                    
                    Divider()
                    
                    LabelWithDetail(
                        "dollarsign.square",
                        "Margin",
                        //entity.totalMargin(in: settings.period).formattedGrouped
                        entity.sold(in: settings.period).marginStr
                    )
                    .foregroundColor(entity.sold(in: settings.period).margin > 0 ? .systemGreen : .systemRed)
                    
                    LabelWithDetail(
                        "percent",
                        "Margin, percentage",
                        //entity.marginPercentage(in: settings.period).formattedPercentage
                        entity.sold(in: settings.period).marginPercentageStr
                    )
                    .foregroundColor(entity.sold(in: settings.period).marginPercentage > 0 ? .systemGreen : .systemRed)
                }
            }
            .font(.subheadline)
            .padding(.vertical, 4)
        }
        
        Section(
            header: Text("Production"),
            footer: Text("Base Products Production Quantity calculated using Products Production.")
        ) {
            VStack(spacing: 8) {
                Group {
                    if entity.closingInventory(in: settings.period) < 0 {
                        Text("Negative Closing Inventory - check Production and Sales Qty of Products!")
                            .foregroundColor(.systemRed)
                    }
                    
                    LabelWithDetail(
                        "wrench.and.screwdriver",
                        "Qty",
                        //entity.productionQty(in: settings.period).formattedGrouped
                        entity.productionQty(in: settings.period).formattedGrouped
                    )
                    
                    LabelWithDetail(
                        "scalemass",
                        "Weight Netto, t",
                        //entity.productionWeightNettoTons(in: settings.period).formattedGroupedWith1Decimal
                        entity.produced(in: settings.period).weightNettoTonsStr
                    )
                    .foregroundColor(.systemRed)
                    
                    LabelWithDetail(
                        "dollarsign.square",
                        "Cost",
                        //entity.productionCostExVAT(in: settings.period).formattedGrouped
                        entity.produced(in: settings.period).cost.fullCostStr
                    )
                }
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            .padding(.vertical, 4)
        }
        
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
}

struct ProductDataSections_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ProductDataSections(Base.example)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("ProductDataSections", displayMode: .inline)
        }
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
