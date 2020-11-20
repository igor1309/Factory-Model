//
//  ProductionCostStructureSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import SwiftUI

struct ProductionCostStructureSection: View {
    
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(
            header: Text("Production Cost Structure")
        ) {
            VStack(alignment: .leading, spacing: 9) {
                DataPointsView(dataBlock: factory.productionIngredientCostExVATDataPoints(in: settings.period))
                    .foregroundColor(Ingredient.color)
                DataPointsView(dataBlock: factory.productionSalaryWithTaxDataPoints(in: settings.period))
                    .foregroundColor(Employee.color)
                DataPointsView(dataBlock: factory.depreciationDataPoints(in: settings.period))
                    .foregroundColor(Equipment.color)
                DataPointsView(dataBlock: factory.utilitiesExVATDataPoints(in: settings.period))
                    .foregroundColor(Utility.color)
            }
            .padding(.vertical, 3)
            
            CostView(factory.produced(in: settings.period).cost)
        }
    }
}

struct ProductionCostStructureSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ProductionCostStructureSection(for: Factory.example)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Test Factory", displayMode: .inline)
        }
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 700))
    }
}
