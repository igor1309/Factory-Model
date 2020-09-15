//
//  CostStructureSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import SwiftUI

struct CostStructureSection: View {
    
    let cost: Cost
    
    var body: some View {
        if cost.costExVAT > 0 {
            Section(
                header: Text(cost.header)
            ) {
                VStack(alignment: .leading, spacing: 4) {
                    HBar(cost.chartData, height: 6)
                        .padding(.top, 3)
                    
                    DataRow(
                        DataPointWithShare(
                            title: "Ingredients",
                            value: cost.ingredientCostExVATStr,
                            percentage: cost.ingredientCostExVATPercentageStr
                        ),
                        color: Ingredient.color//,
                        //icon: Ingredient.icon
                    )
                    
                    DataRow(
                        DataPointWithShare(
                            title: "Salary with tax",
                            value: cost.salaryWithTaxStr,
                            percentage: cost.salaryWithTaxPercentageStr
                        ),
                        color: Employee.color//,
                        //icon: Employee.icon
                    )
                    
                    DataRow(
                        DataPointWithShare(
                            title: "Depreciation",
                            value: cost.depreciationStr,
                            percentage: cost.depreciationPercentageStr
                        ),
                        color: Equipment.color//,
                        //icon: Equipment.icon
                    )
                    
                    DataRow(
                        DataPointWithShare(
                            title: "Utility",
                            value: cost.utilityCostExVATStr,
                            percentage: cost.utilityCostExVATPercentageStr
                        ),
                        color: Utility.color//,
                        //icon: Utility.icon
                    )
                    
                    Divider()
                    
                    DataRow(
                        DataPointWithShare(
                            title: cost.title,
                            value: cost.costExVATStr,
                            percentage: ""
                        ),
                        color: .primary
                    )
                    .padding(.top, 3)
                }
                .padding(.vertical, 3)
            }
        }
    }
}

struct CostStructureSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CostStructureSection(
                cost: Cost(
                    title: "Test Cost",
                    header: "Production Cost Structure",
                    ingredientCostExVAT: 20,
                    salaryWithTax: 15,
                    depreciation: 1,
                    utilityCostExVAT: 2
                )
            )
        }
        .listStyle(InsetGroupedListStyle())
        .preferredColorScheme(.dark)
    }
}
