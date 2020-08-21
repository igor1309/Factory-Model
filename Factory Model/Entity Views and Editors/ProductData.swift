//
//  ThingData.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.08.2020.
//

import SwiftUI
import CoreData

struct ProductData<
    T: Productable & NSManagedObject,
    IngredientDestination: View,
    EmployeeDestination: View,
    EquipmentDestination: View,
    UtilityDestination: View
>: View {
    
    @ObservedObject var entity: T
    
    var ingredientDestination: () -> IngredientDestination
    var employeeDestination: () -> EmployeeDestination
    var equipmentDestination: () -> EquipmentDestination
    var utilityDestination: () -> UtilityDestination
    
    init(
        _ entity: T,
        @ViewBuilder ingredientDestination: @escaping () -> IngredientDestination,
        @ViewBuilder employeeDestination: @escaping () -> EmployeeDestination,
        @ViewBuilder equipmentDestination: @escaping () -> EquipmentDestination,
        @ViewBuilder utilityDestination: @escaping () -> UtilityDestination
    ) {
        self.entity = entity
        self.ingredientDestination = ingredientDestination
        self.employeeDestination = employeeDestination
        self.equipmentDestination = equipmentDestination
        self.utilityDestination = utilityDestination
    }
    
    var body: some View {
        Section(
            header: Text("Cost"),
            footer: Text("Cost, ex VAT")
        ) {
            Group {
                NavigationLink(
                    destination: ingredientDestination()
                ) {
                    LabelWithDetail(Ingredient.icon, "Ingredients Cost, ex VAT", entity.ingredientsExVAT.formattedGroupedWith1Decimal)
                        .foregroundColor(Ingredient.color)
                }
                
                NavigationLink(
                    destination: employeeDestination()
                ) {
                    LabelWithDetail(Department.icon, "Salary incl taxes", entity.salaryWithTax.formattedGroupedWith1Decimal)
                        .foregroundColor(Employee.color)
                }
                
                NavigationLink(
                    destination: equipmentDestination()
                ) {
                    LabelWithDetail(Equipment.icon, "Depreciation", entity.depreciationWithTax.formattedGroupedWith1Decimal)
                        .foregroundColor(Equipment.color)
                }
                
                NavigationLink(
                    destination: utilityDestination()
                ) {
                    LabelWithDetail(Utility.icon, "Utility Cost, ex VAT", entity.utilitiesExVAT.formattedGroupedWith1Decimal)
                        .foregroundColor(Utility.color)
                }
                
                LabelWithDetail("dollarsign.square", "Cost of Base Product", entity.cost.formattedGroupedWith1Decimal)
                    .foregroundColor(.primary)
                    .padding(.trailing)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section {
            Group {
                LabelWithDetail("dollarsign.circle", "Average Price, ex VAT", entity.avgPriceExVAT.formattedGroupedWith1Decimal)
                
                LabelWithDetail("dollarsign.square", "Margin", entity.margin.formattedGroupedWith1Decimal)
                    .foregroundColor(entity.margin > 0 ? .systemGreen : .systemRed)
                
                LabelWithDetail("percent", "Margin, percentage", entity.marginPercentage.formattedPercentage)
                    .foregroundColor(entity.marginPercentage > 0 ? .systemGreen : .systemRed)
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Sales")
        ) {
            Group {
                LabelWithDetail("square", "Total Qty", "\(entity.salesQty.formattedGrouped)")
                
                LabelWithDetail(Sales.icon, "Revenue, ex VAT", entity.revenueExVAT.formattedGrouped)
                
                LabelWithDetail(Sales.icon, "Revenue, with VAT", entity.revenueWithVAT.formattedGrouped)
                    .foregroundColor(.secondary)

                LabelWithDetail("dollarsign.square", "COGS", entity.cogs.formattedGrouped)

                LabelWithDetail("dollarsign.square", "Margin", entity.totalMargin.formattedGrouped)
                    .foregroundColor(entity.totalMargin > 0 ? .systemGreen : .systemRed)
                
                LabelWithDetail("percent", "Margin, percentage", entity.marginPercentage.formattedPercentage)
                    .foregroundColor(entity.marginPercentage > 0 ? .systemGreen : .systemRed)
            }
            .font(.subheadline)
        }
        
        Section(
            header: Text("Production"),
            footer: Text("Base Products Production Quantity calculated using Products Production.")
        ) {
            Group {
                if entity.closingInventory < 0 {
                    Text("Negative Closing Inventory - check Production and Sales Qty of Products!")
                        .foregroundColor(.systemRed)
                }
                
                LabelWithDetail("wrench.and.screwdriver", "Total Qty", "\(entity.productionQty.formattedGrouped)")
                //.foregroundColor(.primary)
                
                LabelWithDetail("square", "TBD Production Volume - unit???", "TBD")
                    .foregroundColor(.systemRed)
                
                LabelWithDetail("dollarsign.square", "Total Cost", entity.productionCostExVAT.formattedGrouped)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        Section(
            header: Text("Inventory")
        ) {
            Group {
                //                AmountPicker(systemName: "building.2", title: "Initial Inventory", navigationTitle: "Initial Inventory", scale: .large, amount: $entity.initialInventory)
                
                LabelWithDetail("building.2", "Closing Inventory", entity.closingInventory.formattedGrouped)
                    .foregroundColor(entity.closingInventory < 0 ? .systemRed : .secondary)
            }
            .font(.subheadline)
        }
    }
}
