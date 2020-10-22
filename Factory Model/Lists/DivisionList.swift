//
//  DivisionList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct DivisionList: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var factory: Factory
    
    let period: Period
    
    init(for factory: Factory, in period: Period) {
        self.factory = factory
        self.period = period
    }
    
    var body: some View {
        EntityListWithDashboard(for: factory, in: period) {
            
            LaborView(for: factory, in: period)
            
            Section(
                header: Text("Personnel")
            ) {
                Group {
                    NavigationLink(
                        destination: AllEmployeesList(for: factory, in: period)
                    ) {
                        Label("All Factory Personnel", systemImage: Department.icon)
                            .foregroundColor(Employee.color)
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        } editor: { (division: Division) in
            DivisionView(division, in: period)
        }
        
    }
}

struct DivisionList_Previews: PreviewProvider {
    static let context = PersistenceManager(containerName: "DataModel").context
    static let period: Period = .month()
    
    static var previews: some View {
        DivisionList(for: Factory.createFactory1(in: context), in: period)
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, context)
    }
}
