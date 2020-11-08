//
//  LaborView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.08.2020.
//

import SwiftUI
import CoreData

struct LaborView<T: NSManagedObject & Laborable>: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var entity: T
    
    init(for entity: T) {
        self.entity = entity
    }
    
    var body: some View {
        Section(
            header: Text("Total")
        ) {
            Group {
                LabelWithDetail("person.crop.rectangle", "Headcount", entity.headcount.formattedGrouped)
                
                LabelWithDetail("clock.arrow.circlepath", "Work Hours", "\(entity.workHours(in: settings.period).formattedGrouped)")
                
                    LabelWithDetail("dollarsign.square", "Salary incl taxes", "\(entity.salaryWithTax(in: settings.period).formattedGrouped)")
                
                    LabelWithDetail("dollarsign.square", "Salary per hour incl taxes", "\(entity.salaryPerHourWithTax(in: settings.period).formattedGrouped)")
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
        
        /// show production totals only for those entities where there is production (ex., headcount > 0)
        if entity.productionHeadcount > 0 {
            Section(
                header: Text("Production")
            ) {
                Group {
                    LabelWithDetail("person.crop.rectangle", "Headcount", entity.productionHeadcount.formattedGrouped)
                    
                    LabelWithDetail("clock.arrow.circlepath", "Work Hours", "\(entity.productionWorkHours(in: settings.period).formattedGrouped)")
                    
                    LabelWithDetail("dollarsign.square", "Salary incl taxes", "\(entity.productionSalaryWithTax(in: settings.period).formattedGrouped)")
                    
                    LabelWithDetail("dollarsign.square", "Salary per hour incl taxes", "\(entity.productionSalaryPerHourWithTax(in: settings.period).formattedGrouped)")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        }
    }
}

struct LaborView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                LaborView(for: Factory.example)
            }
        }
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
