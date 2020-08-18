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
    
    var body: some View {
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
                    
                    context.saveContext()
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(division == nil || name.isEmpty)
            }
        }
    }
}
