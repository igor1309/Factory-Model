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
    
    @EnvironmentObject var settings: Settings
    
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
    
    init(_ department: Department) {
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
    
    @State private var isNewDraftActive = false
    @State private var employeeDrafts = [EmployeeDraft]()
    
    var body: some View {
        NavigationLink(
            destination: CreateEmployee(employeeDrafts: $employeeDrafts),
            isActive: $isNewDraftActive
        ) {
            EmptyView()
        }
        
        List {
            NameSection<Department>(name: $name)
            
            Picker("Type", selection: $type) {
                ForEach(Department.DepartmentType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
                //                    .pickerStyle(SegmentedPickerStyle())
            }
            
            EntityPickerSection(selection: $division, period: settings.period)
            
            DraftSection<Employee, EmployeeDraft>(isNewDraftActive: $isNewDraftActive, drafts: $employeeDrafts)
            
            if let department = departmentToEdit,
               !department.employees.isEmpty {
                GenericListSection(
                    header: "Existing Employees",
                    type: Employee.self,
                    predicate: NSPredicate(format: "%K == %@", #keyPath(Employee.department), department)
                ) { (employee: Employee) in
                    EmployeeEditor(employee)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
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
                var employee = Employee(context: context)
                employee.name = draft.name
                employee.note = draft.note
                employee.position = draft.position
                employee.salary = draft.salary
                employee.period = settings.period
                department.addToEmployees_(employee)
            }
            
            context.saveContext()
            
            isPresented = false
            presentation.wrappedValue.dismiss()
        }
        .disabled(division == nil || name.isEmpty)
    }
}

fileprivate struct CreateEmployee: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var employeeDrafts: [EmployeeDraft]
    
    @State private var name = ""
    @State private var note = ""
    @State private var position = ""
    @State private var salary: Double = 0
    @State private var workHours: Double = 0
    @State private var period: Period = .month()

    var body: some View {
        List {
            NameSection<Employee>(name: $name)
            
            NoteSection(note: $note)
            
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
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Add Employee")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    employeeDrafts.append(
                        EmployeeDraft(
                            name: name,
                            note: note,
                            position: position,
                            salary: salary,
                            workHours: workHours,
                            period: period
                        )
                    )
                    
                    presentation.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || position.isEmpty || salary == 0)
            }
        }
    }
}

struct DepartmentEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                DepartmentEditor(Department.example)
            }
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
