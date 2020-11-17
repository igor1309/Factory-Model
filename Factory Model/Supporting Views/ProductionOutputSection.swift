//
//  ProductionOutputSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.08.2020.
//

import SwiftUI
import CoreData

struct ProductionOutputSection<T: NSManagedObject & Merch>: View {
    @EnvironmentObject private var settings: Settings
    
    let entity: T
    
    init(for entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        Section(header: Text("Production")) {
            productionGroup()
                .foregroundColor(.secondary)
        }
        Section(header: Text("Output")) {
            outputGroup()
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private func productionGroup() -> some View {
        if settings.asStack {
            /// no icons
            VStack(spacing: 6) {
                LabelWithDetail("Output, tonne", entity.produced(in: settings.period).weightNettoTonsStr)
                LabelWithDetail("Cost ex VAT", entity.produced(in: settings.period).cost.fullCostStr)
            }
            .padding(.vertical, 3)
            .font(.footnote)
        } else {
            Group {
                LabelWithDetail("scalemass", "Output, tonne", entity.produced(in: settings.period).weightNettoTonsStr)
                LabelWithDetail("dollarsign.circle", "Cost ex VAT", entity.produced(in: settings.period).cost.fullCostStr)
            }
            .font(.subheadline)
        }
    }
    
    @ViewBuilder
    private func outputGroup() -> some View {
        if settings.asStack {
            /// no icons
            VStack(spacing: 6) {
                LabelWithDetail("Tonne per hour", entity.outputTonnePerHour(in: settings.period).format(percentage: false, decimals: 3))
                LabelWithDetail("Cost ex VAT per hour", entity.productionCostExVATPerHour(in: settings.period).formattedGrouped)
                LabelWithDetail("Cost ex VAT per kilo", entity.productionCostExVATPerKilo(in: settings.period).formattedGrouped)
            }
            .padding(.vertical, 3)
            .font(.footnote)
        } else {
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
    static var settings1 = Settings()
    static var settings2 = Settings()

    static var previews: some View {
        settings1.asStack = true
        settings2.asStack = false
        
        return Group {
            NavigationView {
                Form {
                    ProductionOutputSection(for: Base.example)
                }
            }
            .previewLayout(.fixed(width: 350, height: 350))
            .environmentObject(settings1)
            
            NavigationView {
                Form {
                    ProductionOutputSection(for: Base.example)
                }
            }
            .previewLayout(.fixed(width: 350, height: 450))
            .environmentObject(settings2)
        }
        .environment(\.colorScheme, .dark)
    }
}
