//
//  ProductDataView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.08.2020.
//

import SwiftUI
import CoreData

struct ProductDataSections<
    T: NSManagedObject & Inventorable & Merch,
    IngredientDestination: View,
    EmployeeDestination: View,
    EquipmentDestination: View,
    UtilityDestination: View
>: View {
    
    @ObservedObject var entity: T
    
    let period: Period
    
    var ingredientDestination: () -> IngredientDestination
    var employeeDestination: () -> EmployeeDestination
    var equipmentDestination: () -> EquipmentDestination
    var utilityDestination: () -> UtilityDestination
    
    init(
        _ entity: T,
        in period: Period,
        @ViewBuilder ingredientDestination: @escaping () -> IngredientDestination,
        @ViewBuilder employeeDestination: @escaping () -> EmployeeDestination,
        @ViewBuilder equipmentDestination: @escaping () -> EquipmentDestination,
        @ViewBuilder utilityDestination: @escaping () -> UtilityDestination
    ) {
        self.entity = entity
        self.period = period
        self.ingredientDestination = ingredientDestination
        self.employeeDestination = employeeDestination
        self.equipmentDestination = equipmentDestination
        self.utilityDestination = utilityDestination
    }
    
    private var perKilo: Cost { entity.perKilo(in: period).cost }
    
    var body: some View {
        Section(
            header: Text("Cost"),
            footer: Text("Cost ex VAT, Salary incl taxes.")
        ) {
            Group {
                NavigationLink(
                    destination: ingredientDestination()
                ) {
                    FinLabel(
                        type:       Ingredient.self,
                        title:      "Ingredients",
                        detail:     perKilo.ingredient.valueStr,
                        percentage: perKilo.ingredient.percentageStr
                    )
                }
                
                NavigationLink(
                    destination: employeeDestination()
                ) {
                    FinLabel(
                        type:       Department.self,
                        title:      "Salary",
                        detail:     perKilo.salary.valueStr,
                        percentage: perKilo.salary.percentageStr
                    )
                }
                
                NavigationLink(
                    destination: equipmentDestination()
                ) {
                    FinLabel(
                        type:       Equipment.self,
                        title:      "Depreciation",
                        detail:     perKilo.depreciation.valueStr,
                        percentage: perKilo.depreciation.percentageStr
                    )
                }
                
                NavigationLink(
                    destination: utilityDestination()
                ) {
                    FinLabel(
                        type:       Utility.self,
                        title:      "Utility",
                        detail:     perKilo.utility.valueStr,
                        percentage: perKilo.utility.percentageStr
                    )
                }
                
                HBar([
                    ColorPercentage(Ingredient.color, perKilo.ingredient.percentage),
                    ColorPercentage(Employee.color,   perKilo.salary.percentage),
                    ColorPercentage(Equipment.color,  perKilo.depreciation.percentage),
                    ColorPercentage(Utility.color,    perKilo.utility.percentage)
                ])
                
                HStack(spacing: 0) {
                    LabelWithDetail(
                        "dollarsign.square",
                        "Base Product per Kilo",
                        // entity.cost(in: period).formattedGroupedWith1Decimal
                        entity.perKilo(in: period).cost.fullCostStr
                    )
                    .foregroundColor(.primary)
                    Text("100%").hidden()
                }
                .padding(.trailing)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        
        PriceCostMarginSection(
            priceCostMargin: PCM(
                price: entity.perKilo(in: period).price,
                // cost: entity.cost(in: period)
                //cost: entity.made(in: period).perUnit.cost
                cost: entity.perKilo(in: period).cost.fullCost
            ),
            kind: .perKiloExVAT
        )
        
        Section {
            VStack(spacing: 8) {
                Group {
                    LabelWithDetail(
                        "dollarsign.circle",
                        "Average Price, ex VAT",
                        entity.perKilo(in: period).priceStr
                    )
                    
                    LabelWithDetail(
                        "dollarsign.square",
                        "Margin",
                        //entity.margin(in: period).formattedGroupedWith1Decimal
                        entity.perKilo(in: period).marginStr
                    )
                    .foregroundColor(entity.perKilo(in: period).margin > 0 ? .systemGreen : .systemRed)
                    
                    LabelWithDetail(
                        "percent",
                        "Margin, percentage",
                        //entity.marginPercentage(in: period).formattedPercentage
                        entity.perKilo(in: period).marginPercentageStr
                    )
                    .foregroundColor(entity.perKilo(in: period).marginPercentage > 0 ? .systemGreen : .systemRed)
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
                        // entity.salesQty(in: period).formattedGrouped
                        entity.salesQty(in: period).formattedGrouped
                    )
                    
                    LabelWithDetail(
                        "scalemass",
                        "Weight Netto, t",
                        //entity.salesWeightNettoTons(in: period).formattedGroupedWith1Decimal
                        entity.sold(in: period).weightNettoTonsStr
                    )
                }
                .foregroundColor(.secondary)
                
                Divider()
                
                Group {
                    
                    LabelWithDetail(
                        Sales.icon,
                        "Revenue, ex VAT",
                        //entity.revenueExVAT(in: period).formattedGrouped
                        entity.sold(in: period).priceStr
                    )
                    .foregroundColor(.systemGreen)
                    
//                    LabelWithDetail(
//                        Sales.icon,
//                        "Revenue, with VAT",
//                        entity.revenueWithVAT(in: period).formattedGrouped
//                    )
//                    .foregroundColor(.secondary)
                    
                    LabelWithDetail(
                        "dollarsign.square",
                        "COGS",
                        //entity.cogs(in: period).formattedGrouped
                        entity.sold(in: period).cost.fullCostStr
                    )
                    
                    Divider()
                    
                    LabelWithDetail(
                        "dollarsign.square",
                        "Margin",
                        //entity.totalMargin(in: period).formattedGrouped
                        entity.sold(in: period).marginStr
                    )
                    .foregroundColor(entity.sold(in: period).margin > 0 ? .systemGreen : .systemRed)
                    
                    LabelWithDetail(
                        "percent",
                        "Margin, percentage",
                        //entity.marginPercentage(in: period).formattedPercentage
                        entity.sold(in: period).marginPercentageStr
                    )
                    .foregroundColor(entity.sold(in: period).marginPercentage > 0 ? .systemGreen : .systemRed)
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
                    if entity.closingInventory(in: period) < 0 {
                        Text("Negative Closing Inventory - check Production and Sales Qty of Products!")
                            .foregroundColor(.systemRed)
                    }
                    
                    LabelWithDetail(
                        "wrench.and.screwdriver",
                        "Qty",
                        //entity.productionQty(in: period).formattedGrouped
                        entity.productionQty(in: period).formattedGrouped
                    )
                    
                    LabelWithDetail(
                        "scalemass",
                        "Weight Netto, t",
                        //entity.productionWeightNettoTons(in: period).formattedGroupedWith1Decimal
                        entity.produced(in: period).weightNettoTonsStr
                    )
                    .foregroundColor(.systemRed)
                    
                    LabelWithDetail(
                        "dollarsign.square",
                        "Cost",
                        //entity.productionCostExVAT(in: period).formattedGrouped
                        entity.produced(in: period).cost.fullCostStr
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
                    entity.closingInventory(in: period).formattedGrouped
                )
                .foregroundColor(entity.closingInventory(in: period) < 0 ? .systemRed : .secondary)
            }
            .font(.subheadline)
        }
    }
}
