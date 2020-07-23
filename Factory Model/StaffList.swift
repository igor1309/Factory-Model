//
//  StaffList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct StaffList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest private var staff: FetchedResults<Staff>
    
    @ObservedObject var factory: Factory
    
    init(at factory: Factory) {
        self.factory = factory
        _staff = FetchRequest(
            entity: Staff.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Staff.division_, ascending: true),
                NSSortDescriptor(keyPath: \Staff.department_, ascending: true),
                NSSortDescriptor(keyPath: \Staff.position_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@", factory
            )
        )
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                LabelWithDetail("Total Salary incl taxes", factory.totalSalaryWithTax.formattedGrouped)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Divisions")) {
                ForEach(factory.divisions, id: \.self) { division in
                    NavigationLink(
                        destination: DivisionView(division: division, at: factory)
                    ) {
                        ListRow(
                            title: division + ", \(factory.headcount(for: division))",
                            subtitle: factory.totalSalary(for: division).formattedGrouped,
                            detail: factory.departments(for: division),
                            icon: "person.2"
                        )
                    }
                }
            }
            
            Section(header: Text("Staff")) {
                ForEach(staff, id: \.objectID) { staff in
                    NavigationLink(
                        destination: StaffView(staff)
                    ) {
                        ListRow(staff)
                    }
                }
                .onDelete(perform: removeStaff)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Staff")
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let staff = Staff(context: managedObjectContext)
            staff.name = " ..."
            staff.salary = 10_000
            factory.addToStaff_(staff)
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeStaff(at offsets: IndexSet) {
        for index in offsets {
            let stafff = staff[index]
            managedObjectContext.delete(stafff)
        }
        
        managedObjectContext.saveContext()
    }
}
