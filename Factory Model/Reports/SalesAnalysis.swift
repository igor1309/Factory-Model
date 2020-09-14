//
//  SalesAnalysis.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import SwiftUI

struct SalesAnalysis: View {
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
                    DataBlockView(dataBlock: factory.salesWeightNettoDataPoints(in: period))
                    
                    /// Выручка и доля в выручке
                    DataBlockView(dataBlock: factory.revenueDataPoints(in: period))
                    
                    /// Маржа и доля в марже
                    DataBlockView(dataBlock: factory.marginDataPoints(in: period))
                    
                    // Средняя цена, мин, макс
                    DataBlockView(dataBlock: factory.avgPricePerKiloExVATDataPoints(in: period))
                    
                    /// Маржинальность по каждому и средняя (по всем)
                    DataBlockView(dataBlock: factory.marginPercentageDataPointWithShare(in: period))
                }
                .padding(.bottom)
            }
            .padding()
            .padding(.bottom)
            .padding(.bottom)
        }
        .navigationTitle("Sales Analysis")
    }
}
