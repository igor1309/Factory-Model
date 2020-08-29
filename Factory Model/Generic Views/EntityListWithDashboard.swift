//
//  EntityListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI
import CoreData

struct EntityListWithDashboard<
    Child: Monikerable & Managed & Summarizable & Sketchable & Orphanable & FactoryTracable,
    Parent: NSManagedObject,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var parent: Parent
    
    let title: String
    let useSmallerFont: Bool
    let period: Period
    let keyPathParentToChildren: ReferenceWritableKeyPath<Parent, NSSet?>
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    @FetchRequest private var entities: FetchedResults<Child>
    @FetchRequest private var orphansFetchRequest: FetchedResults<Child>
    
    //  @State private var searchText = ""
    
    /// Creates a View with Dashboard above the Child List with Plus Button in navigation bar. Plus Button icon is taken from Summarizable protocol conformance.
    /// - Parameters:
    ///   - parent: @ObservedObject var
    ///   - title: if nill it uses plural form of Child Entity name
    ///   - useSmallerFont:
    ///   - predicate: if nil it uses defauls predicate
    ///   - keyPathParentToChildren:
    ///   - dashboard: a View above Child list
    ///   - editor: editor for Child
    init(
        for parent: Parent,
        title: String? = nil,
        predicate: NSPredicate? = nil,
        useSmallerFont: Bool = true,
        in period: Period,
        keyPathParentToChildren: ReferenceWritableKeyPath<Parent, NSSet?>,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
        
    ) {
        self.parent = parent
        self.title = title == nil ? Child.plural : title!
        self.useSmallerFont = useSmallerFont
        self.period = period
        self.keyPathParentToChildren = keyPathParentToChildren
        self.dashboard = dashboard
        self.editor = editor
        
        if predicate == nil, type(of: parent) == Factory.self {
            let predicateToUse = Child.factoryPredicate(for: parent as! Factory)
            
            _entities = Child.defaultFetchRequest(with: predicateToUse)
        } else {
            _entities = Child.defaultFetchRequest(with: predicate)
        }
        
        _orphansFetchRequest = Child.defaultFetchRequest(with: Child.orphanPredicate)
    }
    
    var body: some View {
        List {
            //  TextField("Search", text: $searchText)
            
            dashboard()
            
            if !orphansFetchRequest.isEmpty {
                GenericListSection(
                    header: "Orphans",
                    fetchRequest: _orphansFetchRequest,
                    useSmallerFont: useSmallerFont,
                    in: period,
                    editor: editor
                )
                .foregroundColor(.systemRed)
            }
            
            GenericListSection(
                fetchRequest: _entities,
                useSmallerFont: useSmallerFont,
                in: period,
                editor: editor
            )
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(
            trailing:
                CreateChildButton(
                    systemName: Child.plusButtonIcon,
                    childType: Child.self,
                    parent: parent,
                    keyPath: keyPathParentToChildren
                )
        )
    }
}


extension EntityListWithDashboard where Child: Offspringable, Parent == Factory {
    
    init(
        for parent: Parent,
        title: String? = nil,
        useSmallerFont: Bool = true,
        in period: Period,
        predicate: NSPredicate? = nil,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
        
    ) {
        self.init(
            for: parent,
            title: title,
            predicate: predicate,
            useSmallerFont: useSmallerFont,
            in: period,
            keyPathParentToChildren: Child.offspringKeyPath,
            dashboard: dashboard,
            editor: editor)
    }
}
