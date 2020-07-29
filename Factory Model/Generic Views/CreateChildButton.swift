//
//  CreateChildButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.07.2020.
//

import SwiftUI
import CoreData

struct CreateChildButton<Child: Managed & Sketchable,
                         Parent: NSManagedObject>: View {
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var parent: Parent
    var path: String?
    
    let systemName: String
    /// use this init to create orphans (no parent entities)
    /// - Parameter type: type of the Entity to be created
    init(
        systemName: String? = nil,
        childType: Child.Type,
        parent: Parent,
        keyPath: ReferenceWritableKeyPath<Parent, NSSet?>?
    ) {
        self.systemName = systemName == nil ? "plus" : systemName!
        self.parent = parent
        self.path = keyPath?._kvcKeyPathString
    }
    
    var body: some View {
        Button {
            let entity = Child.create(in: context)
            entity.makeSketch()
            
            if let path = path {
                // https://stackoverflow.com/a/55931101
                parent.mutableSetValue(forKeyPath: path /*"bases_"*/).add(entity)
            }
            
            //  do not save - using @ObservedObject
            //  context.saveContext()
        } label: {
            Image(systemName: systemName)
                .padding([.leading, .vertical])
        }
    }
}

struct CreateChildButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            CreateChildButton(childType: Base.self, parent: Factory(), keyPath: \Factory.bases_)
            CreateChildButton(systemName: "plus.circle", childType: Base.self, parent: Factory(), keyPath: \Factory.bases_)
        }
        .preferredColorScheme(.dark)
    }
}
