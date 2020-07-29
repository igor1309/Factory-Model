//
//  ListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

struct ListWithDashboard<
    Child: Monikerable & Managed & Summarable & Validatable & Sketchable & Orphanable,
    Parent: NSManagedObject,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var entities: FetchedResults<Child>
    @FetchRequest private var childFetchRequest: FetchedResults<Child>

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
        _childFetchRequest = Child.defaultFetchRequest(with: Child.orphanPredicate)
    }
    
    var body: some View {
        
        List {
            //  TextField("Search", text: $searchText)
            
            dashboard()
            
            if !childFetchRequest.isEmpty {
                GenericListSection(
                    header: "Orphans",
                    fetchRequest: _childFetchRequest,
                    useSmallerFont: useSmallerFont,
                    editor: editor
                )
                .foregroundColor(.systemRed)
            }
            
            GenericListSection(
                fetchRequest: _entities,
                useSmallerFont: useSmallerFont,
                editor: editor
            )
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(Child.plural())
        //  MARK: - FINISH THIS SHOULD BE CREATE CHILD OR CREATEORPHAN BUTTON!!??
        .navigationBarItems(trailing: CreateChildButton(childType: Child.self, parent: parent, keyPath: keyPath))
    }
}
