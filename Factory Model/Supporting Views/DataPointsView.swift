//
//  DataPointsView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 14.09.2020.
//

import SwiftUI

struct DataPointsView: View {
    var dataBlock: DataBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(dataBlock.title).font(.subheadline)
                Spacer()
                Text(dataBlock.value)
                Text((-2).formattedPercentageWith1Decimal).hidden()
            }
            .font(.footnote)
            
            ForEach(dataBlock.data) { item in
                FinancialRow(item)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 3)
    }
}

struct DataPointsView2: View {
    var dataBlock: DataBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(dataBlock.title).font(.subheadline)
                Spacer()
                Text(dataBlock.value)
                //  Text((-2).formattedPercentage).hidden()
            }
            .font(.footnote)
            
            ForEach(dataBlock.data) { item in
                FinancialRow(item)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 3)
    }    
}

struct DataPointsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section(header: Text("Data Points View")) {
                    DataPointsView(dataBlock: DataBlock.example)
                    
                    DataPointsView(dataBlock: Factory.example.productionIngredientCostExVATDataPoints(in: .month()))
                        .foregroundColor(Ingredient.color)
                    
                    DataPointsView(dataBlock: Factory.example.productionSalaryWithTaxDataPoints(in: .month()))
                        .foregroundColor(Employee.color)
                }
                
                Section(header: Text("Data Points View 2")) {
                    DataPointsView2(dataBlock: DataBlock.example)
                    
                    DataPointsView2(dataBlock: Factory.example.productionIngredientCostExVATPercentageDataPoints(in: .month()))
                        .foregroundColor(Ingredient.color)
                    
                    DataPointsView2(dataBlock: Factory.example.productionSalaryWithTaxPercentageDataPoints(in: .month()))
                        .foregroundColor(Employee.color)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Data Points Views", displayMode:.inline)
        }
        .environment(\.colorScheme, .dark)
        .previewLayout(.fixed(width: 350, height: 800))
    }
}
