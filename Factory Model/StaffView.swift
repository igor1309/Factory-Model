//
//  StaffView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct StaffView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var staff: Staff
    
//    @FetchRequest private var factoryStaff: FetchedResults<Staff>
    
    init(_ staff: Staff) {
        self.staff = staff
//        _factoryStaff = FetchRequest(
//            entity: Staff.entity(),
//            sortDescriptors: [
//                //                NSSortDescriptor(keyPath: \Staff.division_, ascending: true),
//                //                NSSortDescriptor(keyPath: \Staff.department_, ascending: true),
//                //                NSSortDescriptor(keyPath: \Staff.position_, ascending: true)
//            ],
//            predicate: NSPredicate(
//                format: "ANY %K == %@", #keyPath(Staff.factory.staff_), staff
//            )
//        )
    }
    
//    var positions: [String] {
//        factoryStaff
//            .map { $0.position }
//            .removingDuplicates()
//    }
//
//    var departments: [String] {
//        factoryStaff
//            .map { $0.department ??  }
//            .removingDuplicates()
//    }
//
//    var divisions: [String] {
//        factoryStaff
//            .map { $0.division }
//            .removingDuplicates()
//    }
    
    var body: some View {
        List {
            Text("NEEDS TO BE COMPLETLY REDONE")
                .foregroundColor(.systemRed)
                .font(.headline)
            
            Section(header: Text("Person")) {
                Group {
                    TextField("Name", text: $staff.name)
                    TextField("Note", text: $staff.note)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
//            Section(header: Text("Position")) {
//                Group {
//                    StringPicker(title: staff.position, items: positions, selection: $staff.position)
//
//                    StringPicker(title: staff.department, items: departments, selection: $staff.department)
//
//                    StringPicker(title: staff.division, items: divisions, selection: $staff.division)
//                }
//                .foregroundColor(.accentColor)
//                .font(.subheadline)
//            }
            
            Section(header: Text("Salary")) {
                Group {
                    Text("TBD: Salary: \(staff.salary.formattedGrouped)")
                    Text("TBD: Salary: \(staff.salaryWithTax.formattedGrouped)")
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(staff.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct StaffView_Previews: PreviewProvider {
//    static var previews: some View {
//        StaffView()
//    }
//}
