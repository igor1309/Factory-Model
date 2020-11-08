//
//  SalesAnalysis.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.09.2020.
//

import SwiftUI

struct SalesAnalysis: View {
    @EnvironmentObject var settings: Settings
    
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
                    DataBlockView(dataBlock: factory.salesWeightNettoDataPoints(in: settings.period))
                    
                    /// Выручка и доля в выручке
                    DataBlockView(dataBlock: factory.revenueDataPoints(in: settings.period))
                    
                    /// Маржа и доля в марже
                    DataBlockView(dataBlock: factory.marginDataPoints(in: settings.period))
                    
                    // Средняя цена, мин, макс
                    DataBlockView(dataBlock: factory.avgPricePerKiloExVATDataPoints(in: settings.period))
                    
                    /// Маржинальность по каждому и средняя (по всем)
                    DataBlockView(dataBlock: factory.marginPercentageDataPointWithShare(in: settings.period))
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

struct SalesAnalysis_Previews: PreviewProvider {
    static var previews: some View {
        SalesAnalysis(for: Factory.example)
            .environmentObject(Settings())
            .preferredColorScheme(.dark)
    }
}
