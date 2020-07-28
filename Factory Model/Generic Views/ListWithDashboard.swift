//
//  ListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

struct ListWithDashboard<
    Child: Monikerable & Managed & Samplable & Summarable & Validatable & Samplable,
    Parent: NSManagedObject,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var entities: FetchedResults<Child>
    
    //  @State private var searchText = ""
    
    let title: String
    let parent: Parent
    var path: String
    let keyPath: ReferenceWritableKeyPath<Child, Parent>
    let useSmallerFont: Bool
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    init(
        title: String,
        parent: Parent,
        path: String,
        keyPath: ReferenceWritableKeyPath<Child, Parent>,
        predicate: NSPredicate? = nil,
        useSmallerFont: Bool = true,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
    ) {
        self.title = title
        self.parent = parent
        self.path = path
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
                title: title,
                fetchRequest: _entities,
                useSmallerFont: useSmallerFont,
                editor: editor
            )
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: PlusButton(parent: parent, path: path, keyPath: keyPath))
    }
}
