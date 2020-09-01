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
            VStack {//}(alignment: .leading) {
                Text("Sales Analysis")
                    .font(.title)
                    .padding(.bottom)
                
                Group {
                    /// По каждому продукту:
                    /// Выручка и доля в выручке
                    /// Маржа и доля в марже
                    // Маржинальность по каждому и средняя (по всем)
                    // Средняя цена, мин, макс
                    /// Вес нетто и доля а общем весе нетто
                    
                    DataView(
                        icon: "scalemass",
                        title: "Weight Netto, kilo",
                        data: factory.salesWeightNettoDataPoints(in: period)
                    )
                    
                    DataView(
                        icon: "creditcard",
                        title: "Revenue",
                        data: factory.revenueDataPoints(in: period)
                    )
                    
                    DataView(
                        icon: "dollarsign.circle",
                        title: "Margin",
                        data: factory.marginDataPoints(in: period)
                    )
                    
                    //  MARK: - FINISH THIS TBD: FIX %%
                    Text("TBD: FIX %%").foregroundColor(.red)
                    
                    DataView(
                        icon: "dollarsign.circle",
                        title: "TBD: Avg Price ex VAT - FIX %%",
                        data: factory.avgPriceExVATDataPointWithShare(in: period)
                    )
                    
                    DataView(
                        icon: "dollarsign.circle",
                        title: "TBD: Margin, % - FIX %%",
                        data: factory.marginPercentageDataPointWithShare(in: period)
                    )
                }
                .padding(.bottom)
            }
            .padding()
            .padding(.bottom)
            .padding(.bottom)
        }
    }
}
