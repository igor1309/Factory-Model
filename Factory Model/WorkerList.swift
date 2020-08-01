//
//  WorkerList.swift
//  Department Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct WorkerList: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var department: Department
    
    init(at department: Department) {
        self.department = department
    }
    
    var body: some View {
        ListWithDashboard(
            for: department,
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Worker.department), department
            )
        ) {
            CreateChildButton(
                systemName: "person.2",
                childType: Worker.self,
                parent: department,
                keyPath: \Department.workers_
            )
        } dashboard: {
            Section(header: Text("Total")) {
                LabelWithDetail("Total Salary incl taxes", department.totalSalaryWithTax.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        } editor: { (worker: Worker) in
            WorkerView(worker)
        }
        
    }
}
