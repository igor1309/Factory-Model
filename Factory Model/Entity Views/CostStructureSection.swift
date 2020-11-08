//
//  CostStructureSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import SwiftUI

struct CostStructureSection: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(
            header: Text("Base Products Cost Structure")
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
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
