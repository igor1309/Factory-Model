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
        CostSection(factory.produced(in: settings.period).cost) {
            NavigationLink(destination: ProductionCostDetailView(for: factory)) {
                Label("Cost Details", systemImage: "sparkles.rectangle.stack")
                    .foregroundColor(.accentColor)
            }
        }
    }
}

fileprivate struct ProductionCostDetailView: View {
    
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        List {
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
        }
        .navigationTitle("Production Cost Structure")
        .listStyle(InsetGroupedListStyle())
    }
}

struct ProductionCostStructureSection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    ProductionCostStructureSection(for: Factory.example)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Test Factory", displayMode: .inline)
            }
            .previewLayout(.fixed(width: 350, height: 400))
            
            NavigationView {
                ProductionCostDetailView(for: Factory.example)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .previewLayout(.fixed(width: 350, height: 600))
        }
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 700))
    }
}
