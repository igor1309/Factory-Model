//
//  GenericPlusButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

//  MARK: - sample use to create orphans:
//  PlusButton(type: Feedstock.self)

/// if path (and keyPath) is nil we create an orphan!!
struct PlusButton<
    Child: Managed & Samplable,
    Parent: NSManagedObject
>: View {
    @Environment(\.managedObjectContext) var context
    
    var parent: Parent?
    var path: String?
    //  MARK: - FINISH THIS
    //  for now keyPath is used to make a call to GenericPlusButton
    //  understand what is Child type
    //  TASK: make use of keyPath not path string
    //  IDEALLY SHOULD BE LIKE (CRASHES): entity[keyPath: keyPath] = parent
    //  OR entity.setValue(parent, forKeyPath: keyPath)
    
    let keyPath: ReferenceWritableKeyPath<Child, Parent>?
    //    let inverse: ReferenceWritableKeyPath<Parent, NSSet?>
    
    init(
        parent: Parent,
        path: String,
        keyPath: ReferenceWritableKeyPath<Child, Parent>
    ) {
        self.parent = parent
        self.path = path
        self.keyPath = keyPath
    }
    
    /// use this init to create orphans (no parent entities)
    /// - Parameter type: type of the Entity to be created
    init(type: Child.Type) {
        self.parent = nil
        self.path = nil
        self.keyPath = nil
    }
    
    var body: some View {
        Button {
            let entity = Child.create(in: context)
            entity.makeSample()
                 
            ///  if path is nil we create an orphan!!
            if let path = path, let parent = parent {
                /// https://stackoverflow.com/a/55931101
                parent.mutableSetValue(forKeyPath: path/*"bases_"*/).add(entity)
            }

            context.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
