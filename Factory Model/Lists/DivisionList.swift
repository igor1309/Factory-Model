//
//  DivisionList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct DivisionList: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        EntityListWithDashboard(for: factory) {
            Section(
                header: Text("Total")
            ) {
                Group {
                    LabelWithDetail("person.crop.rectangle", "Total Headcount", factory.headcount.formattedGrouped)
                    
                    LabelWithDetail("dollarsign.square", "Total Salary incl taxes", "\(factory.totalSalaryWithTax.formattedGrouped)")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Personnel")
            ) {
                Group {
                    NavigationLink(
                        destination: AllWorkersList(for: factory)
                    ) {
                        Label("All Factory Personnel", systemImage: "person.2")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        } editor: { (division: Division) in
            DivisionView(division)
        }
        
    }
}
