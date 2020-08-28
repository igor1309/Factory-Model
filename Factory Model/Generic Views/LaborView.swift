//
//  LaborView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.08.2020.
//

import SwiftUI
import CoreData

struct LaborView<T: NSManagedObject & Laborable>: View {
    @ObservedObject var entity: T
    
    let period: Period
    
    init(for entity: T, in period: Period) {
        self.entity = entity
        self.period = period
    }
    
    var body: some View {
        Section(
            header: Text("Total")
        ) {
            Group {
                LabelWithDetail("person.crop.rectangle", "Headcount", entity.headcount.formattedGrouped)
                
                LabelWithDetail("clock.arrow.circlepath", "Work Hours", "\(entity.workHours(in: period).formattedGrouped)")
                
                    LabelWithDetail("dollarsign.square", "Salary incl taxes", "\(entity.salaryWithTax(in: period).formattedGrouped)")
                
                    LabelWithDetail("dollarsign.square", "Salary per hour incl taxes", "\(entity.salaryPerHourWithTax(in: period).formattedGrouped)")
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
                    
                    LabelWithDetail("clock.arrow.circlepath", "Work Hours", "\(entity.productionWorkHours(in: period).formattedGrouped)")
                    
                    LabelWithDetail("dollarsign.square", "Salary incl taxes", "\(entity.productionSalaryWithTax(in: period).formattedGrouped)")
                    
                    LabelWithDetail("dollarsign.square", "Salary per hour incl taxes", "\(entity.productionSalaryPerHourWithTax(in: period).formattedGrouped)")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        }
    }
}
