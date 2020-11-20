//
//  ProductionSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.11.2020.
//

import SwiftUI

//  MARK: - FINISH THIS RENAME TO OUTPUT smth ???
//          check ProductionOutputSection

struct ProductionSection: View {
    
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Section(
            header: Text("Production")
        ) {
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
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 350, height: 600))
    }
}
