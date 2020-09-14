//
//  ProductionAnalysis.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import SwiftUI

struct ProductionAnalysis: View {
    let factory: Factory
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                /// По каждому продукту:
                Group {
                    /// Вес нетто и доля а общем весе нетто
                    DataBlockView(dataBlock: factory.productionWeightNettoDataPoints(in: period))
                                        
                    // Средняя себестоимость, мин, макс
                    DataBlockView(dataBlock: factory.avgCostPerKiloExVATDataPoints(in: period))
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
