//
//  ProductionOutputSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.08.2020.
//

import SwiftUI

struct ProductionOutputSection<T: ProductionOutput>: View {
    var entity: T
    
    init(for entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        Section(
            header: Text("Production")
        ) {
            Group {
                LabelWithDetail("scalemass", "Output, tonne", "\(entity.productionWeightNetto)")
                LabelWithDetail("clock.arrow.circlepath", "Work Hours", entity.productionWorkHours.formattedGrouped)
                LabelWithDetail("dollarsign.circle", "Cost ex VAT", entity.productionCostExVAT.formattedGrouped)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        Section(
            header: Text("Output")
        ) {
            Group {
                LabelWithDetail("scalemass.fill", "Output, tonne per hour", entity.outputTonnePerHour.format(percentage: false, decimals: 3))
                LabelWithDetail("dollarsign.square", "Output, cost ex VAT per hour", entity.productionCostExVATPerHour.formattedGrouped)
                LabelWithDetail("dollarsign.square", "Cost ex VAT per kilo", entity.productionCostExVATPerKilo.formattedGrouped)
            }
            .font(.subheadline)
        }
    }
}
