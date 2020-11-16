//
//  CreateEntityPickerButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct CreateEntityPickerButton: View {
    @Environment(\.managedObjectContext) private var context
    
    var isTabItem: Bool = true
    
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
            CreateEntityPicker(isPresented: $showModal)
                .environment(\.managedObjectContext, context)
        }
    }
}


struct CreateEntityPickerButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                CreateEntityPickerButton(isTabItem: false)
            }
            .navigationBarTitle("CreateEntityPickerButton", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    CreateEntityPickerButton()
            )
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)
    }
}
