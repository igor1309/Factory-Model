//
//  ProductionAnalysis.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import SwiftUI

struct ProductionAnalysis: View {
    @EnvironmentObject private var settings: Settings
    
    let factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                /// По каждому продукту:
                Group {
                    /// Вес нетто и доля а общем весе нетто
                    DataBlockView(dataBlock: factory.productionWeightNettoDataPoints(in: settings.period))
                                        
                    // Средняя себестоимость, мин, макс
                    DataBlockView(dataBlock: factory.avgCostPerKiloExVATDataPoints(in: settings.period))
                }
                .padding(.bottom)
            }
            .padding()
            .padding(.bottom)
            .padding(.bottom)
        }
        .navigationTitle("Production Analysis")
    }
}

struct ProductionAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        ProductionAnalysis(for: Factory.example)
            .environmentObject(Settings())
            .preferredColorScheme(.dark)
    }
}
