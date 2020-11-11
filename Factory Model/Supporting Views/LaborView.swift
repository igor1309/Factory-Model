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
    
    @ViewBuilder
    private func laborSection(header: String, headcount: Int, workHours: Double, salaryWithTax: Double, salaryPerHourWithTax: Double, asStack: Bool = true) -> some View {
        
        if asStack {
            Section(header: Text(header)
            ) {
                VStack(spacing: 6) {
                    LabelWithDetail("Headcount", headcount.formattedGrouped)
                    
                    LabelWithDetail("Work Hours", "\(workHours.formattedGrouped)")
                    
                    LabelWithDetail("Salary incl taxes", "\(salaryWithTax.formattedGrouped)")
                    
                    LabelWithDetail("Salary per hour incl taxes", "\(salaryPerHourWithTax.formattedGrouped)")
                }
                .padding(.vertical, 3)
                .foregroundColor(.secondary)
                .font(.footnote)
            }
        } else {
            Section(header: Text(header)
            ) {
                Group {
                    LabelWithDetail("person.crop.rectangle", "Headcount", headcount.formattedGrouped)
                    
                    LabelWithDetail("clock.arrow.circlepath", "Work Hours", "\(workHours.formattedGrouped)")
                    
                    LabelWithDetail("dollarsign.square", "Salary incl taxes", "\(salaryWithTax.formattedGrouped)")
                    
                    LabelWithDetail("dollarsign.square", "Salary per hour incl taxes", "\(salaryPerHourWithTax.formattedGrouped)")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        }
    }
    
    private var productionHeadcount: Int { entity.productionHeadcount }
    private var workHours: Double { entity.workHours(in: settings.period) }
    private var productionWorkHours: Double { entity.productionWorkHours(in: settings.period) }
    private var salaryWithTax: Double { entity.salaryWithTax(in: settings.period) }
    private var productionSalaryWithTax: Double { entity.productionSalaryWithTax(in: settings.period) }
    
    /// there is production departments in this divisions and not all depertments are production
    private var isProductionNotEqualToTotal: Bool {
        productionHeadcount > 0
            && workHours > productionWorkHours
            && salaryWithTax > productionSalaryWithTax
    }
    
    var body: some View {
        laborSection(
            header: "Labor, total",
            headcount: entity.headcount,
            workHours: workHours,
            salaryWithTax: salaryWithTax,
            salaryPerHourWithTax: entity.salaryPerHourWithTax(in: settings.period)
        )
        
        /// show production totals only for those entities where there is production (ex., headcount > 0) and not all are production (in that case it is equal to Total)
        if isProductionNotEqualToTotal {
            laborSection(
                header: "Labor, production",
                headcount: productionHeadcount,
                workHours: productionWorkHours,
                salaryWithTax: productionSalaryWithTax,
                salaryPerHourWithTax: entity.productionSalaryPerHourWithTax(in: settings.period)
            )
        }
    }
}

struct LaborView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                LaborView(for: Factory.example)
            }
            .navigationBarTitle("LaborView", displayMode: .inline)
        }
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
        .previewLayout(.fixed(width: 350, height: 400))
    }
}
