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
        Section(
            header: Text(cost.header)
        ) {
            VStack(alignment: .leading, spacing: 4) {
                DataRow(
                    DataPointWithShare(
                        title: "Ingredients",
                        value: cost.ingredientCostExVATStr,
                        percentage: cost.ingredientCostExVATPercentageStr
                    ),
                    color: Ingredient.color)
                
                DataRow(
                    DataPointWithShare(
                        title: "Salary with tax",
                        value: cost.salaryWithTaxStr,
                        percentage: cost.salaryWithTaxPercentageStr
                    ),
                    color: Employee.color)
                
                DataRow(
                    DataPointWithShare(
                        title: "Depreciation",
                        value: cost.depreciationStr,
                        percentage: cost.depreciationPercentageStr
                    ),
                    color: Equipment.color)
                
                DataRow(
                    DataPointWithShare(
                        title: "Utility",
                        value: cost.utilityCostExVATStr,
                        percentage: cost.utilityCostExVATPercentageStr
                    ),
                    color: Utility.color)
                
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
