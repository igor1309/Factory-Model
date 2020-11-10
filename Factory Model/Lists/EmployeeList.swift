//
//  EmployeeList.swift
//  Department Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EmployeeList: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var department: Department
    
    init(at department: Department) {
        self.department = department
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(Employee.department), department)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            childType: Employee.self,
            for: department,
            predicate: predicate
        ) {
            CreateChildButton(
                childType: Employee.self,
                parent: department,
                keyPathToParent: \Employee.department
            )
        } dashboard: {
            Section(header: Text("Total")) {
                LabelWithDetail("Salary incl taxes", department.salaryWithTax(in: settings.period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        
    }
}

struct EmployeeList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmployeeList(at: Department.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
