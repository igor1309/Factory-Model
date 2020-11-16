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
    
    @EnvironmentObject var settings: Settings
    
    @Binding var isPresented: Bool
    
    let divisionToEdit: Division?
    let title: String
    
    init(isPresented: Binding<Bool>, factory: Factory? = nil) {
        _isPresented = isPresented
        
        divisionToEdit = nil
        
        _name = State(initialValue: "")
        _factory = State(initialValue: factory)
        
        title = "New Division"
    }
    
    init(_ division: Division) {
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
            NameSection<Division>(name: $name)            
            
            EntityPickerSection(selection: $factory, period: settings.period)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let division: Division
            if let divisionToEdit = divisionToEdit {
                division = divisionToEdit
                division.objectWillChange.send()
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

struct DivisionEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    DivisionEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 300))
            
            NavigationView {
                VStack {
                    DivisionEditor(Division.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 300))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
