//
//  StaffList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct StaffList: View {
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
            Section(header: Text("Total Salary".uppercased())) {
//                HStack(alignment: .firstTextBaseline) {
//                    Text("Division Budget")
//                    Spacer()
//
//                    Text("\(factory.salaryForDivision(division), specifier: "%.f")")
//                }
                
                HStack {
                    Text("incl taxes")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(factory.salaryForDivisionWithTax(division), specifier: "%.f")")
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Staff".uppercased())) {
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
                
                Button("Add Staff") {
                    let staff = Staff(context: managedObjectContext)
                    //staff.name = "New Staff"
                    //staff.note = "Some note regarding new staff"
                    staff.division = division
                    //staff.department = "..."
                    //staff.position = "Worker"
                    staff.name = "John"
                    factory.addToStaff_(staff)
                    save()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(division)
    }
    
    private func removeStaff(at offsets: IndexSet) {
        for index in offsets {
            let stafff = staff[index]
            managedObjectContext.delete(stafff)
        }
        
        save()
    }
    
    private func save() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // handle the Core Data error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//struct StaffList_Previews: PreviewProvider {
//    static var previews: some View {
//        StaffList()
//    }
//}
