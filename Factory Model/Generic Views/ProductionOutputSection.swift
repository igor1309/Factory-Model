//
//  ProductionOutputSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.08.2020.
//

import SwiftUI
import CoreData

struct ProductionOutputSection<T: NSManagedObject & ProductionOutput & Costable & WeightNettable>: View {
    @ObservedObject var entity: T
    
    let period: Period
    
    init(for entity: T, in period: Period) {
        self.entity = entity
        self.period = period
    }
    
    var body: some View {
        Section(
            header: Text("Production")
        ) {
            Group {
                LabelWithDetail("scalemass", "Output, tonne", "\(entity.productionWeightNettoTons(in: period))")
                LabelWithDetail("dollarsign.circle", "Cost ex VAT", entity.productionCost(in: period).costExVATStr)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        Section(
            header: Text("Output")
        ) {
            Group {
                LabelWithDetail("scalemass.fill", "Tonne per hour", entity.outputTonnePerHour(in: period).format(percentage: false, decimals: 3))
                LabelWithDetail("dollarsign.square", "Cost ex VAT per hour", entity.productionCostExVATPerHour(in: period).formattedGrouped)
                LabelWithDetail("dollarsign.square", "Cost ex VAT per kilo", entity.productionCostExVATPerKilo(in: period).formattedGrouped)
            }
            .font(.subheadline)
        }
    }
}
