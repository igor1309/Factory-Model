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
        ListWithDashboard(
            predicate: Division.factoryPredicate(for: factory)
        ) {
            CreateChildButton(
                systemName: "rectangle.badge.plus",
                childType: Division.self,
                parent: factory,
                keyPath: \Factory.divisions_
            )
        } dashboard: {
            Section(
                header: Text("Total")
            ) {
                Group {
                    LabelWithDetail("person.crop.rectangle", "Total Headcount", "TBD")
                    
                    LabelWithDetail("dollarsign.square", "Total Salary incl taxes", "\(factory.totalSalaryWithTax.formattedGrouped)")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Personnel")
            ) {
                NavigationLink(
                    destination:
                        List {
                            GenericListSection(
                                type: Worker.self,
                                predicate: Worker.factoryPredicate(for: factory)
                            ) { worker in
                                WorkerView(worker)
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                ) {
                    Label("All Factory Personnel", systemImage: "person.2")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        } editor: { (division: Division) in
            DivisionView(division)
        }
    }
}
