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
    
    var staff: Staff
    
    @State private var draft: Staff
    
    init(_ staff: Staff) {
        self.staff = staff
        _draft = State(initialValue: staff)
    }
    
    var body: some View {
        List {
            Section(header: Text("".uppercased())) {
                Group {
                    TextField("Name", text: $draft.name)
                    TextField("Note", text: $draft.note)
                    TextField("Position", text: $draft.position)
                    TextField("Department", text: $draft.department)
                    TextField("Division", text: $draft.division)
                    Text("TBD: Salary: \(draft.salary, specifier: "%.f")")
                }
                .foregroundColor(.accentColor)
                .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(draft.name)
    }
}

//struct StaffView_Previews: PreviewProvider {
//    static var previews: some View {
//        StaffView()
//    }
//}
