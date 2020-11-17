//
//  ProductDataCostSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 08.11.2020.
//

import SwiftUI
import CoreData

struct ProductDataCostSection<
    T: NSManagedObject & Inventorable & Merch,
    IngredientDestination: View,
    EmployeeDestination: View,
    EquipmentDestination: View,
    UtilityDestination: View
>: View {
    
    @EnvironmentObject private var settings: Settings
    
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
    
    private var perKilo: Cost { entity.perKilo(in: settings.period).cost }
    
    var body: some View {
        Section(
            header: Text("Cost"),
            footer: Text("Cost ex VAT, Salary incl taxes.")
        ) {
            Group {
                NavigationLink(
                    destination: ingredientDestination()
                ) {
                    FinListRow(
                        type:       Ingredient.self,
                        title:      "Ingredients",
                        detail:     perKilo.ingredient.valueStr,
                        percentage: perKilo.ingredient.percentageStr
                    )
                }
                
                NavigationLink(
                    destination: employeeDestination()
                ) {
                    FinListRow(
                        type:       Department.self,
                        title:      "Salary",
                        detail:     perKilo.salary.valueStr,
                        percentage: perKilo.salary.percentageStr
                    )
                }
                
                NavigationLink(
                    destination: equipmentDestination()
                ) {
                    FinListRow(
                        type:       Equipment.self,
                        title:      "Depreciation",
                        detail:     perKilo.depreciation.valueStr,
                        percentage: perKilo.depreciation.percentageStr
                    )
                }
                
                NavigationLink(
                    destination: utilityDestination()
                ) {
                    FinListRow(
                        type:       Utility.self,
                        title:      "Utility",
                        detail:     perKilo.utility.valueStr,
                        percentage: perKilo.utility.percentageStr
                    )
                }
                
                HBar(
                    [ColorPercentage(Ingredient.color, perKilo.ingredient.percentage),
                     ColorPercentage(Employee.color,   perKilo.salary.percentage),
                     ColorPercentage(Equipment.color,  perKilo.depreciation.percentage),
                     ColorPercentage(Utility.color,    perKilo.utility.percentage)],
                    height: 3
                )
                
                FinListRow(
                    systemName: "dollarsign.square",
                    title: "Base Product per Kilo".uppercased(),
                    detail: entity.perKilo(in: settings.period).cost.fullCostStr,
                    percentage: "",
                    color: .primary
                )
                .font(.footnote)
                .padding(.trailing)
            }
            .font(.subheadline)
        }
    }
}

struct ProductDataCostSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ProductDataCostSection(Base.example) {
                    ListWithDashboard(childType: Recipe.self, predicate: nil) {
                        CreateChildButton(parent: Base.example, keyPathToParent: \Recipe.base)
                    } dashboard: {
                        
                    }
                } employeeDestination: {
                    Text("TBD: Labor Cost incl taxes")
                } equipmentDestination: {
                    Text("TBD: Depreciation")
                } utilityDestination: {
                    UtilityList(for: Base.example)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("ProductDataCostSection", displayMode: .inline)
        }
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
