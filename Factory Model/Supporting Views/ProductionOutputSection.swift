//
//  ProductionOutputSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.08.2020.
//

import SwiftUI
import CoreData

struct ProductionOutputSection<T: NSManagedObject & Merch>: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var entity: T
    
    init(for entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        Section(
            header: Text("Production")
        ) {
            Group {
                LabelWithDetail(
                    "scalemass",
                    "Output, tonne",
                    entity.produced(in: settings.period).weightNettoTonsStr
                )
                LabelWithDetail("dollarsign.circle", "Cost ex VAT", entity.produced(in: settings.period).cost.fullCostStr)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        Section(
            header: Text("Output")
        ) {
            Group {
                LabelWithDetail("scalemass.fill", "Tonne per hour", entity.outputTonnePerHour(in: settings.period).format(percentage: false, decimals: 3))
                LabelWithDetail("dollarsign.square", "Cost ex VAT per hour", entity.productionCostExVATPerHour(in: settings.period).formattedGrouped)
                LabelWithDetail("dollarsign.square", "Cost ex VAT per kilo", entity.productionCostExVATPerKilo(in: settings.period).formattedGrouped)
            }
            .font(.subheadline)
        }
    }
}

struct ProductionOutputSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                ProductionOutputSection(for: Base.example)
            }
        }
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
