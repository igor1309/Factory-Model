//
//  EmployeeView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct EmployeeView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var employee: Employee
    
    //    @FetchRequest private var factoryEmployee: FetchedResults<Employee>
    
    init(_ employee: Employee) {
        self.employee = employee
        //        _factoryEmployee = FetchRequest(
        //            entity: Employee.entity(),
        //            sortDescriptors: [
        //                //                NSSortDescriptor(keyPath: \Employee.division_, ascending: true),
        //                //                NSSortDescriptor(keyPath: \Employee.department_, ascending: true),
        //                //                NSSortDescriptor(keyPath: \Employee.position_, ascending: true)
        //            ],
        //            predicate: NSPredicate(
        //                format: "ANY %K == %@", #keyPath(Employee.factory.employee_), employee
        //            )
        //        )
    }
    
    //    var positions: [String] {
    //        factoryEmployee
    //            .map { $0.position }
    //            .removingDuplicates()
    //    }
    //
    //    var departments: [String] {
    //        factoryEmployee
    //            .map { $0.department ??  }
    //            .removingDuplicates()
    //    }
    //
    //    var divisions: [String] {
    //        factoryEmployee
    //            .map { $0.division }
    //            .removingDuplicates()
    //    }
    
    var body: some View {
        List {
            Section(
                header: Text("Person")
            ) {
                Group {
                    TextField("Name", text: $employee.name)
                    TextField("Note", text: $employee.note)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Position")
            ) {
                Group {
                    PickerWithTextField(selection: $employee.position, name: "", values: ["TBD"])
                    //                    StringPicker(title: employee.position, items: positions, selection: $employee.position)
                    //
                    //                    StringPicker(title: employee.department, items: departments, selection: $employee.department)
                    //
                    //                    StringPicker(title: employee.division, items: divisions, selection: $employee.division)
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
            
            Section(
                header: Text("Salary")
            ) {
                Group {
                    AmountPicker(
                        systemName: "dollarsign.circle",
                        title: "Salary ex taxes",
                        navigationTitle: "Salary",
                        scale: .extraLarge,
                        amount: $employee.salary
                    )
                    .foregroundColor(.accentColor)
                    
                    LabelWithDetail("dollarsign.circle", "Salary with tax", employee.salaryWithTax.formattedGrouped)
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)
            }
            
            Section(
                header: Text("Department"),
                footer: Text(employee.department == nil ? "ERROR: no department" : "Department could be changed.")
            ) {
                Group {
                    EntityPicker(
                        selection: $employee.department
                    )
                }
                //  .foregroundColor(.secondary) not .foregroundColor(.accentColor) to hide (diminish possibility of changing Department
                .foregroundColor(employee.department == nil ? .systemRed : .secondary)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(employee.name)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            moc.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct EmployeeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmployeeView()
//    }
//}
