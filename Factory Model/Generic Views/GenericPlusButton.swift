//
//  GenericPlusButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

struct GenericPlusButton<Child: NSManagedObject & Managed & Samplable, Parent: Managed>: View {
    @Environment(\.managedObjectContext) var context
    
    var parent: Parent
    let keyPath: ReferenceWritableKeyPath<Child, Parent>
    
    var body: some View {
        Button {
            let entity = Child.create(in: context)
            entity.makeSample()
            
            entity[keyPath: keyPath] = parent
            context.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
