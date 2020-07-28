//
//  ListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

struct ListWithDashboard<
    Child: Monikerable & Managed & Sketchable & Summarable & Validatable & Sketchable,
    Parent: NSManagedObject,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var entities: FetchedResults<Child>
    
    //  @State private var searchText = ""
    
    let parent: Parent
    var pathFromParent: String
    let keyPath: ReferenceWritableKeyPath<Child, Parent>
    let useSmallerFont: Bool
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    init(
        parent: Parent,
        pathFromParent: String,
        keyPath: ReferenceWritableKeyPath<Child, Parent>,
        predicate: NSPredicate? = nil,
        useSmallerFont: Bool = true,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
    ) {
        self.parent = parent
        self.pathFromParent = pathFromParent
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
        .navigationBarItems(trailing: PlusButton(parent: parent, pathToParent: pathFromParent, keyPath: keyPath))
    }
}
