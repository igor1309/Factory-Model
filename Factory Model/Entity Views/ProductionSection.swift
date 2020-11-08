//
//  ProductionSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 06.11.2020.
//

import SwiftUI

struct ProductionSection: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(
            header: Text("Production")
        ) {
            Group {
                VStack(alignment: .leading, spacing: 9) {
                    DataPointsView(dataBlock: factory.productionWeightNettoDataPoints(in: settings.period, title: "Products, t"))
                        .foregroundColor(Product.color)
                    
                    DataPointsView(dataBlock: factory.basesProductionWeightNettoDataPoints(in: settings.period, title: "Base Products, t"))
                        .foregroundColor(Base.color)
                }
                .padding(.vertical, 3)
                
                NavigationLink(
                    destination:
                        List {
                            ProductionOutputSection(for: factory)
                        }
                        .listStyle(InsetGroupedListStyle())
                        .navigationTitle("Output")
                ) {
                    ListRow(
                        title: "Output",
                        subtitle: "TBD ...(?)",
                        detail: "Production Benchmarks?",
                        icon: "cylinder.split.1x2.fill",
                        color: .systemPurple
                    )
                }
                
                NavigationLink(
                    destination: ProductList(for: factory)
                ) {
                    ListRow(
                        title: "Products",
                        subtitle: factory.productsDetail(in: settings.period),
                        detail: "",
                        icon: Product.icon,
                        color: Product.color
                    )
                }
                
                NavigationLink(
                    destination: BaseList(for: factory)
                ) {
                    ListRow(
                        title: "Base Products",
                        subtitle: factory.basesDetail(in: settings.period),
                        detail: "",
                        icon: Base.icon,
                        color: Base.color
                    )
                }
                
                VStack(alignment: .leading, spacing: 9) {
                    DataPointsView(dataBlock: factory.productionIngredientCostExVATDataPoints(in: settings.period))
                        .foregroundColor(Ingredient.color)
                    //.padding(.top, 3)
                    DataPointsView(dataBlock: factory.productionSalaryWithTaxDataPoints(in: settings.period))
                        .foregroundColor(Employee.color)
                    DataPointsView(dataBlock: factory.depreciationDataPoints(in: settings.period))
                        .foregroundColor(Equipment.color)
                    DataPointsView(dataBlock: factory.utilitiesExVATDataPoints(in: settings.period))
                        .foregroundColor(Utility.color)
                    //.padding(.bottom, 3)
                }
                .padding(.vertical, 3)
            }
        }
    }
}

struct ProductionSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ProductionSection(for: Factory.example)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Test Factory", displayMode: .inline)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
