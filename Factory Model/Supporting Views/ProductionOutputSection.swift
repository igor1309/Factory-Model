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
        SectionAsStackOrGroup(header: "Production", labelGroup: productionGroup(), asStack: settings.asStack)
        
        SectionAsStackOrGroup(header: "Output", labelGroup: outputGroup(), asStack: settings.asStack)
    }
    
    private func productionGroup() -> some View {
        Group {
            LabelWithDetail(
                settings.asStack ? nil : "scalemass",
                "Output, tonne",
                entity.produced(in: settings.period).weightNettoTonsStr
            )
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.circle",
                "Cost ex VAT",
                entity.produced(in: settings.period).cost.fullCostStr
            )
        }
    }
    
    private func outputGroup() -> some View {
        Group {
            LabelWithDetail(
                settings.asStack ? nil : "scalemass.fill",
                "Tonne per hour",
                entity.outputTonnePerHour(in: settings.period).format(percentage: false, decimals: 3))
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.square",
                "Cost ex VAT per hour",
                entity.productionCostExVATPerHour(in: settings.period).formattedGrouped)
            LabelWithDetail(
                settings.asStack ? nil : "dollarsign.square",
                "Cost ex VAT per kilo",
                entity.productionCostExVATPerKilo(in: settings.period).formattedGrouped)
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
