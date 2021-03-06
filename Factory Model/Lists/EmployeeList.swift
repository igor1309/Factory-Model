//
//  EmployeeList.swift
//  Department Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EmployeeList: View {
    
    @EnvironmentObject private var settings: Settings
    
    let department: Department?
    let factory: Factory?
    let predicate: NSPredicate
    
    init(at department: Department) {
        self.department = department
        self.factory = nil
        self.predicate = NSPredicate(format: "%K == %@", #keyPath(Employee.department), department)
    }
    
    init(for factory: Factory) {
        self.department = nil
        self.factory = factory
        self.predicate = Employee.factoryPredicate(for: factory)
    }
    
    var body: some View {
        ListWithDashboard(
            childType: Employee.self,
            predicate: predicate,
            plusButton: plusButton,
            dashboard: dashboard
        )
    }
    
    @ViewBuilder
    private func plusButton() -> some View {
        if let department = department {
            CreateChildButton(parent: department, keyPathToParent: \Employee.department)
        } else if let _ = factory {
            CreateNewEntityButton<Employee>()
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        if let department = department {
            Section(header: Text("\(department.name) Total")) {
                LabelWithDetail("Salary incl taxes", department.salaryWithTax(in: settings.period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        } else if let factory = factory {
            Section(header: Text("\(factory.name) Total")) {
                LabelWithDetail("Salary incl taxes", factory.salaryWithTax(in: settings.period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        } else {
            EmptyView()
        }
    }
}

struct EmployeeList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EmployeeList(at: Department.example)
            }
            .previewLayout(.fixed(width: 350, height: 450))
            
            NavigationView {
                EmployeeList(for: Factory.example)
            }
            .previewLayout(.fixed(width: 350, height: 600))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
