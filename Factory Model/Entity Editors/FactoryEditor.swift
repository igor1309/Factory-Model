//
//  FactoryEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct FactoryEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var isPresented: Bool
    
    let factoryToEdit: Factory?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        factoryToEdit = nil
        
        _name = State(initialValue: "")
        _note = State(initialValue: "")
        _profitTaxRate = State(initialValue: 20/100)
        _salaryBurdenRate = State(initialValue: 30.2/100)
        
        title = "New Factory"
    }
    
    init(_ factory: Factory) {
        _isPresented = .constant(true)
        
        factoryToEdit = factory
        
        _name = State(initialValue: factory.name)
        _note = State(initialValue: factory.note)
        _profitTaxRate = State(initialValue: factory.profitTaxRate)
        _salaryBurdenRate = State(initialValue: factory.salaryBurdenRate)
        
        title = "Edit Factory"
    }
    
    @State private var name: String
    @State private var note: String
    @State private var profitTaxRate: Double
    @State private var salaryBurdenRate: Double
    
    var body: some View {
        List {
            NameSection<Factory>(name: $name)
            
            NoteSection(note: $note)
            
            AmountPicker(systemName: "scissors", title: "Profit Tax Rate", navigationTitle: "Profit Tax Rate", scale: .percent, amount: $profitTaxRate)
            
            AmountPicker(systemName: "scalemass.fill", title: "Salary Burden Rate", navigationTitle: "Salary Burden Rate", scale: .percent, amount: $salaryBurdenRate)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let haptics = Haptics()
            haptics.haptic()
            
            withAnimation {
                let factory: Factory
                
                if let factoryToEdit = factoryToEdit {
                    factory = factoryToEdit
                    factory.objectWillChange.send()
                } else {
                    factory = Factory(context: context)
                }
                
                factory.name = name
                factory.note = note
                factory.profitTaxRate = profitTaxRate
                factory.salaryBurdenRate = salaryBurdenRate
                
                context.saveContext()
                
                isPresented = false
                presentation.wrappedValue.dismiss()
            }
        }
        .disabled(name.isEmpty || profitTaxRate == 0)
    }
}

struct FactoryEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    FactoryEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 420))
            
            NavigationView {
                VStack {
                    FactoryEditor(Factory.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 420))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
