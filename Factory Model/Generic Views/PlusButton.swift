//
//  GenericPlusButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

struct PlusButton<
    Child: NSManagedObject & Managed & Samplable,
    Parent: NSManagedObject
>: View {
    @Environment(\.managedObjectContext) var context
    
    var parent: Parent
    var path: String
    //  MARK: - FINISH THIS
    //  for now keyPath is used to make a call to GenericPlusButton
    //  understand what is Child type
    //  TASK: make use of keyPath not path string
    //  IDEALLY SHOULD BE LIKE (CRASHES): entity[keyPath: keyPath] = parent
    //  OR entity.setValue(parent, forKeyPath: keyPath)
    let keyPath: ReferenceWritableKeyPath<Child, Parent>
    //    let inverse: ReferenceWritableKeyPath<Parent, NSSet?>
    
    var body: some View {
        Button {
            let entity = Child.create(in: context)
            entity.makeSample()
                        
            /// https://stackoverflow.com/a/55931101
            parent.mutableSetValue(forKeyPath: path/*"bases_"*/).add(entity)

            context.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
