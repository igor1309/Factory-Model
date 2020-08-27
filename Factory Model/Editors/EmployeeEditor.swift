//
//  EmployeeEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct EmployeeEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let employeeToEdit: Employee?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        employeeToEdit = nil
        
        _name = State(initialValue: "")
        _note = State(initialValue: "")
        _position = State(initialValue: "")
        _salary = State(initialValue: 0)
        _workHours = State(initialValue: 0)
        _department = State(initialValue: nil)
        
        title = "New Employee"
    }
    
    init(_ employee: Employee) {
        _isPresented = .constant(true)
        
        employeeToEdit = employee
        
        _name = State(initialValue: employee.name)
        _note = State(initialValue: employee.note)
        _position = State(initialValue: employee.position)
        _salary = State(initialValue: employee.salary)
        _workHours = State(initialValue: employee.workHours)
        _department = State(initialValue: employee.department)
        
        title = "Edit Employee"
    }
    
    @State private var name: String
    @State private var note: String
    @State private var position: String
    @State private var salary: Double
    @State private var workHours: Double
    @State private var department: Department?
    
    var body: some View {
        List {
            NameSection<Employee>(name: $name)
            
            Section(
                header: Text("Position")
            ) {
                Group {
                    PickerWithTextField(selection: $position, name: "", values: ["TBD"])
                }
                .foregroundColor(.accentColor)
            }
            
            Section(
                header: Text("Salary"),
                footer: Text("Standart work week 40 hours, standart month 168 hours.")
            ) {
                Group {
                    AmountPicker(
                        systemName: "dollarsign.circle",
                        title: "Salary ex taxes",
                        navigationTitle: "Salary",
                        scale: .extraLarge,
                        amount: $salary
                    )
                    
                    AmountPicker(
                        systemName: "clock.arrow.circlepath",
                        title: "Work Hours",
                        navigationTitle: "Work Hours",
                        scale: .extraSmall,
                        amount: $workHours
                    )
                    
                    Picker("Work Hours", selection: $workHours) {
                        ForEach([40.0, 168], id: \.self) { item in
                            Text("\(item.formattedGrouped)h")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .foregroundColor(.accentColor)
            }
            
            EntityPickerSection(selection: $department)
            
            TextField("Note", text: $note)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let employee: Employee
            if let employeeToEdit = employeeToEdit {
                employee = employeeToEdit
            } else {
                employee = Employee(context: context)
            }
            
            employee.name = name
            employee.note = note
            employee.position = position
            employee.salary = salary
            employee.workHours = workHours
            employee.department = department
            
            context.saveContext()
            
            isPresented = false
            presentation.wrappedValue.dismiss()
        }
        .disabled(department == nil || name.isEmpty || position.isEmpty || salary <= 0 || workHours <= 0)
    }
}
