//
//  CostSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import SwiftUI

struct CostSection: View {
    
    let cost: Cost
    var showBarChart: Bool
    var barHeight: CGFloat
    
    init(_ cost: Cost, showBarChart: Bool) {
        self.cost = cost
        self.showBarChart = false
        self.barHeight = 3
    }
    
    init(_ cost: Cost, barHeight: CGFloat = 3) {
        self.cost = cost
        self.showBarChart = true
        self.barHeight = barHeight
    }
    
    var body: some View {
        if cost.fullCost > 0 {
            Section(
                header: Text(cost.header)
            ) {
                VStack(alignment: .leading, spacing: 4) {
                    FinancialRow(
                        DataPointWithShare(
                            title: "Ingredients",
                            value: cost.ingredient.valueStr,
                            percentage: cost.ingredient.percentageStr
                        )
                    )
                    .foregroundColor(Ingredient.color)
                    
                    FinancialRow(
                        DataPointWithShare(
                            title: "Salary with tax",
                            value: cost.salary.valueStr,
                            percentage: cost.salary.percentageStr
                        )
                    )
                    .foregroundColor(Employee.color)
                    
                    FinancialRow(
                        DataPointWithShare(
                            title: "Depreciation",
                            value: cost.depreciation.valueStr,
                            percentage: cost.depreciation.percentageStr
                        )
                    )
                    .foregroundColor(Equipment.color)
                    
                    FinancialRow(
                        DataPointWithShare(
                            title: "Utility",
                            value: cost.utility.valueStr,
                            percentage: cost.utility.percentageStr
                        )
                    )
                    .foregroundColor(Utility.color)
                    
                    if showBarChart {
                        HBar(cost.chartData, height: barHeight)
                            .padding(.top, 3)
                    } else {
                        Divider()
                    }
                    
                    FinancialRow(
                        DataPointWithShare(
                            title: cost.title,
                            value: cost.fullCostStr,
                            percentage: ""
                        )
                    )
                    .foregroundColor(.primary)
                }
                .padding(.vertical, 3)
            }
        }
    }
}

struct CostSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            CostSection(Cost.example, showBarChart: false)
            
            CostSection(Cost.example, barHeight: 6)
            CostSection(Cost.example, barHeight: 3)
        }
        .preferredColorScheme(.dark)
    }
}
