//
//  CreateChildButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.07.2020.
//

import SwiftUI
import CoreData
import Combine

struct CreateChildButton<Child: Managed & Sketchable,
                         Parent: NSManagedObject>: View {
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var parent: Parent

    var path: String?
    let keyPath: ReferenceWritableKeyPath<Parent, NSSet?>?
    let systemName: String

    init(
        systemName: String? = nil,
        childType: Child.Type,
        parent: Parent,
        keyPath: ReferenceWritableKeyPath<Parent, NSSet?>?
    ) {
        self.systemName = systemName == nil ? "plus" : systemName!
        self.parent = parent
        self.path = keyPath?._kvcKeyPathString
        self.keyPath = keyPath
    }
    
    var body: some View {
        Button {
            let entity = Child.create(in: context)
            entity.makeSketch()
            entity.objectWillChange.send()
            
            if let path = path {
                // https://stackoverflow.com/a/55931101
                parent.mutableSetValue(forKeyPath: path /*"bases_"*/).add(entity)
                parent.objectWillChange.send()
                //  MARK: - FINISH THIS Enroute L12 @ CS193p ТАК НУЖНО?????? КАК ЭТО СДЕЛАТЬ???
//                parent[keyPath: keyPath]?.forEach { $0.objectWillChange.send() }
//                airport.flightsFrom.forEach { $0.objectWillChange.send() }
            }
            
            try? context.save()
            //  context.saveContext() crashes while using @ObservedObject
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
