//
//  DepartmentList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 08.11.2020.
//

import SwiftUI

struct DepartmentList: View {
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var body: some View {
        Text("TBD")
        /*
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
         } editor: { (division: Department) in
         DepartmentView(division)
         }
         */
    }
}

struct DepartmentList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DepartmentList(for: Factory.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
