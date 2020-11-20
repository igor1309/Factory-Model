//
//  CostStructureSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import SwiftUI

struct CostStructureSection: View {
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(
            header: Text("Production Cost Structure")
        ) {
            DataPointsView2(dataBlock: factory.productionIngredientCostExVATPercentageDataPoints(in: settings.period))
                .foregroundColor(Ingredient.color)
                .padding(.top, 3)
            
            DataPointsView2(dataBlock: factory.productionSalaryWithTaxPercentageDataPoints(in: settings.period))
                .foregroundColor(Employee.color)
            
            DataPointsView2(dataBlock: factory.depreciationPercentageDataPoints(in: settings.period))
                .foregroundColor(Equipment.color)
            
            DataPointsView2(dataBlock: factory.utilitiesExVATPercentageDataPoints(in: settings.period))
                .foregroundColor(Utility.color)
                .padding(.bottom, 3)
        }
    }
}

struct CostStructureSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                CostStructureSection(for: Factory.example)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Test Factory", displayMode: .inline)
        }
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 600))
    }
}
