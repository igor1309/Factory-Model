//
//  ListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

struct ListWithDashboard<
    Child: Monikerable & Managed & Summarable & Validatable & Sketchable,
    Parent: NSManagedObject,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var entities: FetchedResults<Child>
    
    //  @State private var searchText = ""
    
    let parent: Parent
    let keyPath: ReferenceWritableKeyPath<Parent, NSSet?>?
    let useSmallerFont: Bool
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    init(
        parent: Parent,
        keyPath: ReferenceWritableKeyPath<Parent, NSSet?>?,
        predicate: NSPredicate? = nil,
        useSmallerFont: Bool = true,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
    ) {
        self.parent = parent
        self.keyPath = keyPath
        self.useSmallerFont = useSmallerFont
        self.dashboard = dashboard
        self.editor = editor
        _entities = Child.defaultFetchRequest(with: predicate)
    }
    
    var body: some View {
        
        List {
            //  TextField("Search", text: $searchText)
            
            dashboard()
            
            GenericListSection(
                fetchRequest: _entities,
                useSmallerFont: useSmallerFont,
                editor: editor
            )
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Child.plural())
        .navigationBarItems(trailing: PlusButton(childType: Child.self, parent: parent, keyPath: keyPath))
    }
}
