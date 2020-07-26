//
//  StaffList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct DivisionView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var staff: FetchedResults<Staff>
    
    @ObservedObject var factory: Factory
    let division: String
    
    init(division: String, at factory: Factory) {
        self.factory = factory
        self.division = division
        _staff = FetchRequest(
            entity: Staff.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Staff.position_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@ and division_ = %@", factory, division
            )
        )
    }
    
    
    var body: some View {
        List {
            Text("MARK: NEED TO BE DONE IN A CORRECT WAY")
                .foregroundColor(.systemRed)
                .font(.headline)
            
            Section(header: Text("Total")) {
                LabelWithDetail("Total Salary incl taxes", factory.salaryForDivisionWithTax(division).formattedGrouped)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Staff (\(factory.headcount(for: division)))")
            ) {
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
        .navigationTitle(division)
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            //  MARK: NEED TO BE DONE IN A CORRECT WAY
            let staff = Staff(context: moc)
            staff.name = " ..."
            staff.salary = 10_000
            
            let department = Department(context: moc)
            department.addToStaffs_(staff)
            
            factory.addToDepartments_(department)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeStaff(at offsets: IndexSet) {
        for index in offsets {
            let stafff = staff[index]
            moc.delete(stafff)
        }
        
        moc.saveContext()
    }
}
