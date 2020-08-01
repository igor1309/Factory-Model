//
//  CreateOrphanButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.07.2020.
//

import SwiftUI
import CoreData

struct CreateOrphanButton<Child: Managed & Sketchable>: View {
    @Environment(\.managedObjectContext) var context
    
    let systemName: String
    /// use this init to create orphans (no parent entities)
    /// - Parameter type: type of the Entity to be created
    init(systemName: String? = nil) {
        self.systemName = systemName == nil ? "plus" : systemName!
    }

    var body: some View {
        Button {
            let entity = Child.create(in: context)
            entity.makeSketch()
            entity.objectWillChange.send()
            
            context.saveContext()
        } label: {
            Image(systemName: systemName)
                .padding([.leading, .vertical])
        }
    }
}


struct CreateOrphanButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            CreateOrphanButton<Base>()
            CreateOrphanButton<Base>(systemName: "plus.circle")
        }
        .preferredColorScheme(.dark)
    }
}