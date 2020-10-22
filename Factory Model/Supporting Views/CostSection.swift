//
//  CostSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import SwiftUI

struct CostSection: View {
    
    let cost: Cost
    var showBarChart = true
    
    var body: some View {
        if cost.fullCost > 0 {
            Section(
                header: Text(cost.header)
            ) {
                VStack(alignment: .leading, spacing: 4) {
                    if showBarChart {
                        HBar(cost.chartData, height: 6)
                            .padding(.top, 3)
                    }
                    
                    DataRow(
                        DataPointWithShare(
                            title: "Ingredients",
                            value: cost.ingredient.valueStr,
                            percentage: cost.ingredient.percentageStr
                        ),
                        color: Ingredient.color//,
                        //icon: Ingredient.icon
                    )
                    
                    DataRow(
                        DataPointWithShare(
                            title: "Salary with tax",
                            value: cost.salary.valueStr,
                            percentage: cost.salary.percentageStr
                        ),
                        color: Employee.color//,
                        //icon: Employee.icon
                    )
                    
                    DataRow(
                        DataPointWithShare(
                            title: "Depreciation",
                            value: cost.depreciation.valueStr,
                            percentage: cost.depreciation.percentageStr
                        ),
                        color: Equipment.color//,
                        //icon: Equipment.icon
                    )
                    
                    DataRow(
                        DataPointWithShare(
                            title: "Utility",
                            value: cost.utility.valueStr,
                            percentage: cost.utility.percentageStr
                        ),
                        color: Utility.color//,
                        //icon: Utility.icon
                    )
                    
                    Divider()
                    
                    DataRow(
                        DataPointWithShare(
                            title: cost.title,
                            value: cost.fullCostStr,
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

//struct CostStructureSection_Previews: PreviewProvider {
//    static var previews: some View {
//        List {
//            CostSection(
//                cost: Cost(
//                    title: "Test Cost",
//                    header: "Production Cost Structure",
//                    ingredient: 20,
//                    salary: 15,
//                    depreciation: 1,
//                    utility: 2
//                )
//            )
//        }
//        .listStyle(InsetGroupedListStyle())
//        .preferredColorScheme(.dark)
//    }
//}
