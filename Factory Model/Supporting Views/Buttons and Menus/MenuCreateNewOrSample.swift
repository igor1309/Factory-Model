//
//  CreateNewEntityButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 02.08.2020.
//

import SwiftUI
import CoreData

struct MenuCreateNewOrSample: View {
    @Environment(\.managedObjectContext) private var context
    
    @State private var isPresented = false
    
    var body: some View {
        Menu {
            Section(header: Text("Sample Factory")) {
                Button {
                    withAnimation {
                        let _ = Factory.createFactory1(in: context)
                        context.saveContext()
                    }
                } label: {
                    Label("Сыроварня", systemImage: "plus")
                }
                
                Button {
                    withAnimation {
                        let _ = Factory.createFactory2(in: context)
                        context.saveContext()
                    }
                } label: {
                    Label("Полуфабрикаты", systemImage: "plus")
                }
            }
            
            CreateNewEntityButton<Equipment>(kind: .label)
            
            Section(header: Text("Create Entity")) {
                CreateEntityPicker(isPresented: $isPresented, asCard: false)
            }
            
            Section(header: Text("Create Entity")) {
                CreateEntityPickerButton(isTabItem: false)
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

struct MenuCreateNewOrSample_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color
                .blue
                .opacity(0.2)
                .padding()
                .navigationBarTitle("MenuCreateNewOrSample", displayMode: .inline)
                .navigationBarItems(trailing: MenuCreateNewOrSample())
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)
    }
}
