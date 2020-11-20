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
    
    init(isPresented: Binding<Bool>, parent: Department? = nil) {
        _isPresented = isPresented
        
        employeeToEdit = nil
        
        _name =       State(initialValue: "")
        _note =       State(initialValue: "")
        _position =   State(initialValue: "")
        _salary =     State(initialValue: 0)
        _period =     State(initialValue: Period.month())
        _department = State(initialValue: parent)
        
        title = "New Employee"
    }
    
    init(_ employee: Employee) {
        _isPresented = .constant(true)
        
        employeeToEdit = employee
        
        _name =       State(initialValue: employee.name)
        _note =       State(initialValue: employee.note)
        _position =   State(initialValue: employee.position)
        _salary =     State(initialValue: employee.salary)
        _period =     State(initialValue: employee.period)
        _department = State(initialValue: employee.department)
        
        title = "Edit Employee"
    }
    
    @State private var name: String
    @State private var note: String
    @State private var position: String
    @State private var salary: Double
    @State private var period: Period
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
                    AmountPicker(systemName: "dollarsign.circle", title: "Salary ex taxes", navigationTitle: "Salary", scale: .extraLarge, amount: $salary)
                        .foregroundColor(salary > 0 ? .systemBlue : .systemRed)
                    
                    PeriodPicker(icon: "deskclock", title: "Period", period: $period)
                }
                //.foregroundColor(.accentColor)
            }
            
            EntityPickerSection(selection: $department, period: period)
            
            NoteSection(note: $note)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let haptics = Haptics()
            haptics.feedback()
            
            withAnimation {
                var employee: Employee
                
                if let employeeToEdit = employeeToEdit {
                    employee = employeeToEdit
                    employee.objectWillChange.send()
                } else {
                    employee = Employee(context: context)
                }
                
                employee.department?.objectWillChange.send()
                
                employee.name = name
                employee.note = note
                employee.position = position
                employee.salary = salary
                employee.period = period
                employee.department = department
                
                context.saveContext()
                
                isPresented = false
                presentation.wrappedValue.dismiss()
            }
        }
        .disabled(department == nil || name.isEmpty || position.isEmpty || salary <= 0)
    }
}

struct EmployeeEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    EmployeeEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 700))
            
            NavigationView {
                VStack {
                    EmployeeEditor(Employee.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 700))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
