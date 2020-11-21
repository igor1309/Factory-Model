//
//  CostView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.09.2020.
//

import SwiftUI


struct CostSection<V: View>: View {
    typealias Bottom = () -> V
    
    let cost: Cost
    let showBarChart: Bool
    let barHeight: CGFloat
    let bottom: Bottom?
    
    init(_ cost: Cost, showBarChart: Bool, bottom: Bottom? = nil) {
        self.cost = cost
        self.showBarChart = false
        self.barHeight = 3
        self.bottom = bottom
    }
    
    init(_ cost: Cost, barHeight: CGFloat = 3, bottom: Bottom? = nil) {
        self.cost = cost
        self.showBarChart = true
        self.barHeight = barHeight
        self.bottom = bottom
    }
    
    var body: some View {
        if cost.fullCost > 0 {
            Section(
                header: Text(cost.header)
            ) {
                if showBarChart {
                    CostView(cost, barHeight: barHeight)
                } else {
                    CostView(cost, showBarChart: false)
                }
                
                if let bottom = bottom {
                    bottom()
                }
            }
        }
    }
}

struct CostView: View {
    
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
            VStack(alignment: .leading, spacing: 4) {
                
                ForEach(cost.components) { item in
                    FinancialRow(
                        DataPointWithShare(
                            title: item.title,
                            value: item.valueStr,
                            percentage: item.percentageStr
                        )
                    )
                    .foregroundColor(item.color)
                }
                                
                VStack(spacing: 0) {
                    if showBarChart {
                        HBar(cost.chartData, height: barHeight)
                            .padding(.top, 3)
                    } else {
                        Divider()
                            .padding(.bottom, 3)
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
            }
            .padding(.vertical, 3)
        }
    }
}

struct CostSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section(header: Text("Cost Views")) {
                    CostView(Cost.example, barHeight: 3)
                    CostView(Cost.example, barHeight: 6)
                    
                    CostView(Cost.example, showBarChart: false)
                }
                
                Text("Cost Sections below")
                CostSection<EmptyView>(Cost.example, barHeight: 3)
                CostSection(Cost.example, showBarChart: false) {
                    NavigationLink(destination: Text("<Extra here>")) {  Text("More…")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Cost Views & Sections", displayMode: .inline)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 1000))
    }
}
