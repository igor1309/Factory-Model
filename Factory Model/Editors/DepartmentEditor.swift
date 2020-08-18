//
//  DepartmentEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct DepartmentEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let departmentToEdit: Department?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        departmentToEdit = nil
        
        _name = State(initialValue: "")
        _type = State(initialValue: .production)
        _division = State(initialValue: nil)
        
        title = "New Department"
    }
    
    init(department: Department) {
        _isPresented = .constant(true)
        
        departmentToEdit = department
        
        _name = State(initialValue: department.name)
        _type = State(initialValue: department.type)
        _division = State(initialValue: department.division)
        
        title = "Edit Department"
    }
    
    @State private var name: String
    @State private var type: Department.DepartmentType
    @State private var division: Division?
    
    @State private var isEmployeeDraftActive = false
    @State private var employeeDrafts = [EmployeeDraft]()
    
    var body: some View {
        NavigationLink(
            destination: CreateEmployee(employeeDrafts: $employeeDrafts),
            isActive: $isEmployeeDraftActive
        ) {
            EmptyView()
        }
        
        List {
            Section(
                header: Text(name.isEmpty ? "" : "Edit Department Name")
            ) {
                TextField("Department Name", text: $name)
            }
            
            Picker("Type", selection: $type) {
                ForEach(Department.DepartmentType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
                //                    .pickerStyle(SegmentedPickerStyle())
            }
            
            EntityPickerSection(selection: $division)
            
            Section(
                header: Text("Employees")
            ) {
                Button {
                    isEmployeeDraftActive = true
                } label: {
                    Label("Add Employee", systemImage: Employee.plusButtonIcon)
                }
                
                ForEach(employeeDrafts) { item in
                    //  MARK: - FINISH THIS
                    //  make nice row, see ListRow for example
                    Text(item.title)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let department: Department
                    if let departmentToEdit = departmentToEdit {
                        department = departmentToEdit
                    } else {
                        department = Department(context: context)
                    }
                    
                    department.name = name
                    department.type = type
                    department.division = division
                    
                    for draft in employeeDrafts {
                        let employee = Employee(context: context)
                        employee.name = draft.name
                        employee.note = draft.note
                        employee.position = draft.position
                        employee.salary = draft.salary
                        department.addToEmployees_(employee)
                    }
                    
                    context.saveContext()
                    
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(division == nil || name.isEmpty)
            }
        }
    }
}

fileprivate struct EmployeeDraft: Identifiable {
    var name: String
    var note: String
    var position: String
    var salary: Double
    
    var id = UUID()
    var title: String {
        "\(name) \(position) \(salary)"
    }
}


fileprivate struct CreateEmployee: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var employeeDrafts: [EmployeeDraft]
    
    @State private var name = ""
    @State private var note = ""
    @State private var position = ""
    @State private var salary: Double = 0
    
    var body: some View {
        List {
            Section(
                header: Text(name.isEmpty ? "" : "Edit Employee Name")
            ) {
                TextField("Employee Name", text: $name)
            }
            
            TextField("Note", text: $note)
            
            Section(
                header: Text("Position")
            ) {
                Group {
                    PickerWithTextField(selection: $position, name: "", values: ["TBD"])
                }
                .foregroundColor(.accentColor)
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
                        amount: $salary
                    )
                    .foregroundColor(.accentColor)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Add Employee")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    employeeDrafts.append(
                        EmployeeDraft(name: name, note: note, position: position, salary: salary)
                    )
                    
                    presentation.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || position.isEmpty || salary == 0)
            }
        }
    }
}
