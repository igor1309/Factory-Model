//
//  StaffList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct DivisionView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var staff: FetchedResults<Staff>
    
    var factory: Factory
    let division: String
    
    init(division: String, at factory: Factory) {
        self.factory = factory
        self.division = division
        _staff = FetchRequest(
            entity: Staff.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Staff.division_, ascending: true),
                NSSortDescriptor(keyPath: \Staff.department_, ascending: true),
                NSSortDescriptor(keyPath: \Staff.position_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@ and division_ = %@", factory, division
            )
        )
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Total Salary")) {
                LabelWithDetail("incl taxes", factory.salaryForDivisionWithTax(division).formattedGroupedWith1Decimal)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Staff (\(factory.headcount(for: division)))")
            ) {
                ForEach(staff, id: \.self) { staff in
                    NavigationLink(
                        destination: StaffView(staff)
                    ) {
                        ListRow(title: staff.name,
                                subtitle: "\(staff.salary)" + (staff.note_ == nil ? "" : ", " + staff.note),
                                detail: staff.department + ": " + staff.position,
                                icon: "person.2")
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
            let staff = Staff(context: managedObjectContext)
            staff.name = " ..."
            staff.division = division
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

//struct StaffList_Previews: PreviewProvider {
//    static var previews: some View {
//        DivisionView()
//    }
//}
