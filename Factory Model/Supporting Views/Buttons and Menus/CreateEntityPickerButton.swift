//
//  CreateEntityPickerButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct CreateEntityPickerButton: View {
    @Environment(\.managedObjectContext) private var context
    
    let factory: Factory?
    var isTabItem: Bool
    
    @State private var showModal = false
    
    var body: some View {
        Button {
            showModal = true
        } label: {
            if isTabItem {
                Image(systemName: "plus.rectangle.on.rectangle")
            } else {
                Label("Create Entity", systemImage: "plus.rectangle.on.rectangle")
            }
        }
        .sheet(isPresented: $showModal) {
            CreateEntityPicker(isPresented: $showModal, factory: factory, asCard: true)
                .environment(\.managedObjectContext, context)
        }
    }
}


struct CreateEntityPickerButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                CreateEntityPickerButton(factory: nil, isTabItem: false)
            }
            .navigationBarTitle("CreateEntityPickerButton", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    CreateEntityPickerButton(factory: nil, isTabItem: true)
            )
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)
    }
}
