//
//  ProductDataView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.08.2020.
//

import SwiftUI
import CoreData

struct ProductDataSections<
    T: NSManagedObject & Productable & Costable & Inventorable & Marginable & WeightNettable,
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
    
    private var unitCost: Cost { entity.unitCost(in: period) }
    
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
                        type: Ingredient.self,
                        title: "Ingredients",
                        detail:     unitCost.ingredientCostExVATStr,
                        percentage: unitCost.ingredientCostExVATPercentageStr
                    )
                }
                
                NavigationLink(
                    destination: employeeDestination()
                ) {
                    FinLabel(
                        type: Department.self,
                        title: "Salary",
                        detail:     unitCost.salaryWithTaxStr,
                        percentage: unitCost.salaryWithTaxPercentageStr
                    )
                }
                
                NavigationLink(
                    destination: equipmentDestination()
                ) {
                    FinLabel(
                        type: Equipment.self,
                        title: "Depreciation",
                        detail:     unitCost.depreciationStr,
                        percentage: unitCost.depreciationPercentageStr
                    )
                }
                
                NavigationLink(
                    destination: utilityDestination()
                ) {
                    FinLabel(
                        type: Utility.self,
                        title: "Utility",
                        detail:     unitCost.utilityCostExVATStr,
                        percentage: unitCost.utilityCostExVATPercentageStr
                    )
                }
                
                HBar([
                    ColorPercentage(Ingredient.color, unitCost.ingredientCostExVATPercentage),
                    ColorPercentage(Employee.color,   unitCost.salaryWithTaxPercentage),
                    ColorPercentage(Equipment.color,  unitCost.depreciationPercentage),
                    ColorPercentage(Utility.color,    unitCost.utilityCostExVATPercentage)
                ])
                
                HStack(spacing: 0) {
                    LabelWithDetail("dollarsign.square", "Base Product", entity.cost(in: period).formattedGroupedWith1Decimal)
                        .foregroundColor(.primary)
                    Text("100%").hidden()
                }
                .padding(.trailing)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section {
            Group {
                LabelWithDetail("dollarsign.circle", "Average Price, ex VAT", entity.avgPriceExVAT(in: period).formattedGroupedWith1Decimal)
                
                LabelWithDetail("dollarsign.square", "Margin", entity.margin(in: period).formattedGroupedWith1Decimal)
                    .foregroundColor(entity.margin(in: period) > 0 ? .systemGreen : .systemRed)
                
                LabelWithDetail("percent", "Margin, percentage", entity.marginPercentage(in: period).formattedPercentage)
                    .foregroundColor(entity.marginPercentage(in: period) > 0 ? .systemGreen : .systemRed)
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Sales")
        ) {
            Group {
                LabelWithDetail("square", "Qty", "\(entity.salesQty(in: period).formattedGrouped)")
                
                    LabelWithDetail(Sales.icon, "Revenue, ex VAT", entity.revenueExVAT(in: period).formattedGrouped)
                    .foregroundColor(.systemGreen)
                
                    LabelWithDetail(Sales.icon, "Revenue, with VAT", entity.revenueWithVAT(in: period).formattedGrouped)
                    .foregroundColor(.secondary)
                
                    LabelWithDetail("dollarsign.square", "COGS", entity.cogs(in: period).formattedGrouped)
                
                    LabelWithDetail("dollarsign.square", "Margin", entity.totalMargin(in: period).formattedGrouped)
                    .foregroundColor(entity.totalMargin(in: period) > 0 ? .systemGreen : .systemRed)
                
                    LabelWithDetail("percent", "Margin, percentage", entity.marginPercentage(in: period).formattedPercentage)
                    .foregroundColor(entity.marginPercentage(in: period) > 0 ? .systemGreen : .systemRed)
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Production"),
            footer: Text("Base Products Production Quantity calculated using Products Production.")
        ) {
            Group {
                if entity.closingInventory(in: period) < 0 {
                    Text("Negative Closing Inventory - check Production and Sales Qty of Products!")
                        .foregroundColor(.systemRed)
                }
                
                    LabelWithDetail("wrench.and.screwdriver", "Qty", entity.productionQty(in: period).formattedGrouped)
                
                    LabelWithDetail("scalemass", "Weight Netto, t", entity.productionWeightNettoTons(in: period).formattedGroupedWith1Decimal)
                    .foregroundColor(.systemRed)
                
                    LabelWithDetail("dollarsign.square", "Cost", entity.productionCostExVAT(in: period).formattedGrouped)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section(
            header: Text("Inventory")
        ) {
            Group {
                //                AmountPicker(systemName: "building.2", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $entity.initialInventory)
                
                    LabelWithDetail("building.2", "Closing Inventory", entity.closingInventory(in: period).formattedGrouped)
                    .foregroundColor(entity.closingInventory(in: period) < 0 ? .systemRed : .secondary)
            }
            .font(.subheadline)
        }
    }
}
