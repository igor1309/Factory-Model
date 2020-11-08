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
        
    var body: some View {
        Menu {
            Section(header: Text("Sample Factory")) {
                Button {
                    withAnimation {
                        let _ = Factory.createFactory1(in: context)
                    }
                } label: {
                    Label("Сыроварня", systemImage: "plus")
                }
                
                Button {
                    withAnimation {
                        let _ = Factory.createFactory2(in: context)
                    }
                } label: {
                    Label("Полуфабрикаты", systemImage: "plus")
                }
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
