//
//  CreateEntityPickerButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct CreateEntityPickerButton: View {
    
    @Environment(\.managedObjectContext) private var context
    
    let period: Period

    @State private var showModal = false
    
    var body: some View {
        Button {
            showModal = true
        } label: {
            Image(systemName: "plus.rectangle.on.rectangle")
        }
        .sheet(isPresented: $showModal) {
            CreateEntityPicker(isPresented: $showModal, period: period)
                .environment(\.managedObjectContext, context)
        }
    }
}
