//
//  UtilityEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 18.08.2020.
//

import SwiftUI

struct UtilityEditor: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @EnvironmentObject var settings: Settings
    
    @Binding var isPresented: Bool
    
    let utilityToEdit: Utility?
    let title: String
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        
        utilityToEdit = nil
        
        _name = State(initialValue: "")
        _priceExVAT = State(initialValue: 0)
        _vat = State(initialValue: 10/100)
        _base = State(initialValue: nil)
        
        title = "New Utility"
    }
    
    init(_ utility: Utility) {
        _isPresented = .constant(true)
        
        utilityToEdit = utility
        
        _name = State(initialValue: utility.name)
        _priceExVAT = State(initialValue: utility.priceExVAT)
        _vat = State(initialValue: utility.vat)
        _base = State(initialValue: utility.base)
        
        title = "Edit Utility"
    }
    
    @State private var name: String
    @State private var priceExVAT: Double
    @State private var vat: Double
    @State private var base: Base?
    
    var body: some View {
        List {
            NameSection<Utility>(name: $name)
            
            Section(
                header: Text("Price"),
                footer: Text("Price per Unit of Base Product")
            ) {
                AmountPicker(systemName: "dollarsign.circle", title: "Utility Price, ex VAT", navigationTitle: "Utility Price", scale: .small, amount: $priceExVAT)
                    .foregroundColor(priceExVAT > 0 ? .systemBlue : .systemRed)
                
                AmountPicker(systemName: "scissors", title: "Utility VAT", navigationTitle: "Utility VAT", scale: .percent, amount: $vat)
            }
            
            EntityPickerSection(selection: $base, period: settings.period)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: saveButton)
    }
    
    private var saveButton: some View {
        Button("Save") {
            let utility: Utility
            if let utilityToEdit = utilityToEdit {
                utility = utilityToEdit
            } else {
                utility = Utility(context: context)
            }
            
            utility.name = name
            utility.priceExVAT = priceExVAT
            utility.vat = vat
            utility.base = base
            
            context.saveContext()
            
            isPresented = false
            presentation.wrappedValue.dismiss()
        }
        .disabled(name.isEmpty || priceExVAT == 0 || vat == 0 || base == nil)
    }
}

struct UtilityEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    UtilityEditor(isPresented: .constant(true))
                }
            }
            .previewLayout(.fixed(width: 345, height: 500))
            
            NavigationView {
                VStack {
                    UtilityEditor(Utility.example)
                }
            }
            .previewLayout(.fixed(width: 345, height: 500))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
