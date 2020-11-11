//
//  EmployeeList.swift
//  Department Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EmployeeList: View {
    
    @EnvironmentObject var settings: Settings
    
    let department: Department?
    let factory: Factory?
    
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
    
    private let predicate: NSPredicate
    
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
            CreateChildButton(
                childType: Employee.self,
                parent: department,
                keyPathToParent: \Employee.department
            )
        } else if let _ = factory {
            CreateNewEntityBarButton<Employee>()
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func dashboard() -> some View {
        if let department = department {
            Section(header: Text("Total")) {
                LabelWithDetail("Salary incl taxes", department.salaryWithTax(in: settings.period).formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        } else if let factory = factory {
            EmptyView()
            Section(header: Text("Total")) {
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
            
            NavigationView {
                EmployeeList(for: Factory.example)
            }
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
