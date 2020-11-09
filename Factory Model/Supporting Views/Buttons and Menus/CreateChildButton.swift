//
//  CreateChildButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.07.2020.
//

import SwiftUI
import CoreData
import Combine

struct CreateChildButton<Child: Managed & Summarizable & Sketchable,
                         Parent: NSManagedObject>: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var parent: Parent
    
    var path: String?
    let keyPath: ReferenceWritableKeyPath<Parent, NSSet?>?
    let systemName: String
    let title: String
    
    init(
        systemName: String? = nil,
        childType: Child.Type,
        parent: Parent,
        keyPath: ReferenceWritableKeyPath<Parent, NSSet?>?
    ) {
        self.systemName = systemName ?? Child.plusButtonIcon
        self.title = ""
        self.parent = parent
        self.path = keyPath?._kvcKeyPathString
        self.keyPath = keyPath
    }
    
    init(
        title: String,
        childType: Child.Type,
        parent: Parent,
        keyPath: ReferenceWritableKeyPath<Parent, NSSet?>?
    ) {
        self.systemName = ""
        self.title = title
        self.parent = parent
        self.path = keyPath?._kvcKeyPathString
        self.keyPath = keyPath
    }
    
    var body: some View {
        Button {
            withAnimation {
                //  MARK: - which one to use??
                let entity = Child(context: context)
                //let entity = Child.create(in: context)
                //entity.objectWillChange.send()
                
                if let path = path {
                    parent.objectWillChange.send()
                    // https://stackoverflow.com/a/55931101
                    parent.mutableSetValue(forKeyPath: path /*"bases_"*/).add(entity)
                    //  MARK: - FINISH THIS Enroute L12 @ CS193p ТАК НУЖНО?????? КАК ЭТО СДЕЛАТЬ???
                    // parent[keyPath: keyPath]?.forEach { $0.objectWillChange.send() }
                    // airport.flightsFrom.forEach { $0.objectWillChange.send() }
                }
                
                try? context.save()
                //  context.saveContext() crashes while using @ObservedObject
                //  context.saveContext()
            }
        } label: {
            if title.isEmpty {
                Image(systemName: systemName)
                    .padding([.leading, .vertical])
            } else {
                Text(title)
            }
        }
    }
}

struct CreateChildButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BaseList(for: Factory.example)
            .navigationBarTitle("Base: Create Child Button", displayMode: .inline)
            .navigationBarItems(
                trailing: HStack {
                    CreateChildButton(
                        childType: Base.self,
                        parent: Factory(),
                        keyPath: \Factory.bases_
                    )
                    CreateChildButton(
                        systemName: "plus.circle",
                        childType: Base.self,
                        parent: Factory(),
                        keyPath: \Factory.bases_
                    )
                }
            )
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
