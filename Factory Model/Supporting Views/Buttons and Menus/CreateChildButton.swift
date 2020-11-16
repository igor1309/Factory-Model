//
//  CreateChildButton.swift
//  Factory Model
//
//  Created by Igor Malyarov on 29.07.2020.
//

import SwiftUI
import CoreData

struct CreateChildButton<Child: Summarizable & Sketchable,
                         Parent: NSManagedObject>: View {
    
    @Environment(\.managedObjectContext) private var context
    
    //  MARK: - или просто let будет достаточно?
    // @ObservedObject var parent: Parent
    let parent: Parent
    
    let keyPathToParent: ReferenceWritableKeyPath<Child, Parent?>
    let systemName: String
    let title: String
    
    
    init(
        systemName: String? = nil,
        parent: Parent,
        keyPathToParent: ReferenceWritableKeyPath<Child, Parent?>
    ) {
        self.systemName = systemName ?? Child.plusButtonIcon
        self.title = ""
        self.parent = parent
        self.keyPathToParent = keyPathToParent
    }
    
    init(
        title: String,
        parent: Parent,
        keyPathToParent: ReferenceWritableKeyPath<Child, Parent?>
    ) {
        self.systemName = ""
        self.title = title
        self.parent = parent
        self.keyPathToParent = keyPathToParent
    }
    
    var body: some View {
        Button {
            withAnimation {
                parent.objectWillChange.send()
                
                let entity = Child(context: context)
                entity.makeSketch()
                entity[keyPath: keyPathToParent] = parent
                
                context.saveContext()
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
    static let factory = Factory.example
    static let base = Base.example
    
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    GenericListSection(type: Product.self, predicate: NSPredicate(format: "base == %@", base))
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Products: Create Child Button", displayMode: .inline)
                .navigationBarItems(trailing: CreateChildButton(parent: base, keyPathToParent: \Product.base))
            }
            
            NavigationView {
                EquipmentList(for: factory)
                    .navigationBarTitle("Equipments: Create Child Button", displayMode: .inline)
                    .navigationBarItems(trailing: CreateChildButton(parent: factory, keyPathToParent: \Equipment.factory))
            }
            
            NavigationView {
                DivisionList(for: factory)
                    .navigationBarTitle("Divisions: Create Child Button", displayMode: .inline)
                    .navigationBarItems(trailing: CreateChildButton(parent: factory, keyPathToParent: \Division.factory))
            }
            
            NavigationView {
                //  MARK: - FINISH THIS IT CRASHES!!
                BaseList(for: factory)
                    .navigationBarTitle("Base: Create Child Button", displayMode: .inline)
                    .navigationBarItems(trailing: CreateChildButton(parent: factory, keyPathToParent: \Base.factory))
            }
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
