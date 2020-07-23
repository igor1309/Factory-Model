//
//  StaffView.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct StaffView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var staff: Staff
    
    init(_ staff: Staff) {
        self.staff = staff
    }
    
    var body: some View {
        List {
            Section(header: Text("")) {
                Group {
                    TextField("Name", text: $staff.name)
                    TextField("Note", text: $staff.note)
                    TextField("Position", text: $staff.position)
                    TextField("Department", text: $staff.department)
                    TextField("Division", text: $staff.division)
                    Text("TBD: Salary: \(staff.salary, specifier: "%.f")")
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
            managedObjectContext.saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
}

//struct StaffView_Previews: PreviewProvider {
//    static var previews: some View {
//        StaffView()
//    }
//}
