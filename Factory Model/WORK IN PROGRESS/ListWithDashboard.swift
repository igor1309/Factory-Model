//
//  ListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

struct ListWithDashboard<
    Child: Monikerable & Managed & Samplable & Summarable & Validatable,
    Parent: NSManagedObject,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var entities: FetchedResults<Child>
    
    let title: String
    let parent: Parent
    let useSmallerFont: Bool
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor

    init(
        title: String,
        parent: Parent,
        predicate: NSPredicate? = nil,
        useSmallerFont: Bool = true,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
    ) {
        self.title = title
        self.parent = parent
        self.useSmallerFont = useSmallerFont
        self.dashboard = dashboard
        self.editor = editor
        _entities = Child.defaultFetchRequest(with: predicate)
    }
    
    var body: some View {
        
        List {
            dashboard()
            
            GenericListSection(
                title: title,
                fetchRequest: _entities,
                useSmallerFont: useSmallerFont,
                editor: editor
            )
            //  dashboard
            
            // GenericListSection
            
            Text("Hello, World!")
            
        }
        //  nav things
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        
        //  generic plus button
//        .navigationBarItems(trailing: PlusButton(parent: pa, path: "expenses_", keyPath: \Expenses.factory!))
    }
}
