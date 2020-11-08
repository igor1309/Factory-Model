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
    
    @Environment(\.managedObjectContext) private var context
    
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
        self.systemName = systemName ?? "plus"
        self.parent = parent
        self.keyPath = keyPath
        self.path = ""//keyPath?._kvcKeyPathString
    }
    
    var body: some View {
        Button {
            withAnimation {
                let entity = Child.create(in: context)
                entity.makeSketch()
                
                parent[keyPath: keyPath] = entity
                
                entity.objectWillChange.send()
                parent.objectWillChange.send()
                //  do not save - using @ObservedObject
                //  context.saveContext()
            }
        } label: {
            Image(systemName: systemName)
                .padding([.leading, .vertical])
        }
    }
}

struct CreateSoloChildButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Color
                .blue
                .opacity(0.2)
                .padding()
                .navigationBarTitle("CreateSoloChildButton", displayMode: .inline)
                .navigationBarItems(
                    trailing: HStack {
                        CreateSoloChildButton(
                            parent: Recipe.example,
                            keyPath: \Recipe.base
                        )
                        CreateSoloChildButton(
                            systemName: "plus.circle",
                            parent: Recipe.example,
                            keyPath: \Recipe.base
                        )
                    }
                )
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)
    }
}
