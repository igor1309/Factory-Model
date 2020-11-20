//
//  LaborView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 25.08.2020.
//

import SwiftUI
import CoreData

struct LaborView<T: NSManagedObject & Laborable>: View {
    @EnvironmentObject private var settings: Settings
    
    let entity: T
    
    init(for entity: T) {
        self.entity = entity
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
    
    private func laborSection(header: String, headcount: Int, workHours: Double, salaryWithTax: Double, salaryPerHourWithTax: Double) -> some View {
        
        func groupOfLabels() -> some View {
            Group {
                LabelWithDetail(
                    settings.asStack ? nil : "person.crop.rectangle",
                    "Headcount",
                    headcount.formattedGrouped
                )
                
                LabelWithDetail(
                    settings.asStack ? nil : "clock.arrow.circlepath",
                    "Work Hours",
                    "\(workHours.formattedGrouped)"
                )
                
                LabelWithDetail(
                    settings.asStack ? nil : "dollarsign.square",
                    "Salary incl taxes",
                    "\(salaryWithTax.formattedGrouped)"
                )
                
                LabelWithDetail(
                    settings.asStack ? nil : "dollarsign.square",
                    "Salary per hour incl taxes",
                    "\(salaryPerHourWithTax.formattedGrouped)"
                )
            }
        }
        
        return SectionAsStackOrGroup(header: header, labelGroup: groupOfLabels(), asStack: settings.asStack)
    }
}

struct LaborView_Previews: PreviewProvider {
    static var settings1 = Settings()
    static var settings2 = Settings()
    
    static var previews: some View {
        settings1.asStack = true
        settings2.asStack = false
        
        return Group {
            NavigationView {
                Form {
                    LaborView(for: Factory.example)
                }
                .navigationBarTitle("LaborView", displayMode: .inline)
                .environmentObject(settings1)
            }
            .previewLayout(.fixed(width: 350, height: 430))
            
            NavigationView {
                Form {
                    LaborView(for: Factory.example)
                }
                .navigationBarTitle("LaborView", displayMode: .inline)
                .environmentObject(settings2)
            }
            .previewLayout(.fixed(width: 350, height: 570))
        }
        .environment(\.colorScheme, .dark)
    }
}
