//
//  CreateEntityPickerButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct CreateEntityPickerButton: View {
    @Environment(\.managedObjectContext) private var context
    
    @State private var showModal = false
    
    var body: some View {
        Button {
            showModal = true
        } label: {
            Image(systemName: "plus.rectangle.on.rectangle")
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
            Color
                .blue
                .opacity(0.2)
                .padding()
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
