//
//  DivisionEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct DivisionEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let divisionToEdit: Division?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        divisionToEdit = nil
        
        _name = State(initialValue: "")
        _factory = State(initialValue: nil)
        
        title = "New Division"
    }
    
    init(division: Division) {
        _isPresented = .constant(true)
        
        divisionToEdit = division
        
        _name = State(initialValue: division.name)
        _factory = State(initialValue: division.factory)
        
        title = "Edit Division"
    }
    
    @State private var name: String
    @State private var factory: Factory?
    
    var body: some View {
        List {
            Section(
                header: Text(name.isEmpty ? "" : "Edit Division Name")
            ) {
                TextField("Division Name", text: $name)
            }
            
            EntityPickerSection(selection: $factory)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let division: Division
                    if let divisionToEdit = divisionToEdit {
                        division = divisionToEdit
                    } else {
                        division = Division(context: context)
                    }
                    
                    division.name = name
                    division.factory = factory
                    
                    context.saveContext()
                    isPresented = false
                    presentation.wrappedValue.dismiss()
                }
                .disabled(factory == nil || name.isEmpty)
            }
        }
    }
}
