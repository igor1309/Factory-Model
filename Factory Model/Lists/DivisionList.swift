//
//  DivisionList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct DivisionList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        EntityListWithDashboard(for: factory) {
            
            LaborView(for: factory)
            
            Section(
                header: Text("Personnel")
            ) {
                Group {
                    NavigationLink(
                        destination: AllEmployeesList(for: factory)
                    ) {
                        Label("All Factory Personnel", systemImage: Department.icon)
                            .foregroundColor(Employee.color)
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

struct DivisionList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DivisionList(for: Factory.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
