//
//  CreateSoloChildButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.07.2020.
//

import SwiftUI
import CoreData

struct CreateSoloChildButton<Child: Managed & Sketchable,
                             Parent: NSManagedObject>: View {
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var parent: Parent
    
    let keyPath: ReferenceWritableKeyPath<Parent, Child?>
    var path: String?
    
    let systemName: String
    /// use this init to create orphans (no parent entities)
    /// - Parameter type: type of the Entity to be created
    init(
        systemName: String? = nil,
//        childType: Child.Type,
        parent: Parent,
        keyPath: ReferenceWritableKeyPath<Parent, Child?>
    ) {
        self.systemName = systemName == nil ? "plus" : systemName!
        self.parent = parent
        self.keyPath = keyPath
        self.path = ""//keyPath?._kvcKeyPathString
    }
    
    var body: some View {
        Button {
            let entity = Child.create(in: context)
            entity.makeSketch()
            
            parent[keyPath: keyPath] = entity
            
            //  do not save - using @ObservedObject
            //  context.saveContext()
        } label: {
            Image(systemName: systemName)
                .padding([.leading, .vertical])
        }
    }
}

struct CreateSoloChildButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            CreateSoloChildButton(
                //childType: Buyer.self,
                parent: Sales(), keyPath: \Sales.buyer)
            CreateSoloChildButton(systemName: "plus.circle",
                                  //childType: Sales.self,
                                  parent: Buyer(), keyPath: \Buyer.sales)
        }
        .preferredColorScheme(.dark)
    }
}
