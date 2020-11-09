//
//  EntityListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI
import CoreData

struct EntityListWithDashboard<
    Child: Dashboardable & FactoryTracable,
    Parent: NSManagedObject,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var parent: Parent
    
    let title: String
    let smallFont: Bool
    let keyPathParentToChildren: ReferenceWritableKeyPath<Parent, NSSet?>
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    //  @State private var searchText = ""
    
    /// Creates a View with Dashboard above the Child List with Plus Button in navigation bar. Plus Button icon is taken from Summarizable protocol conformance.
    /// - Parameters:
    ///   - parent: @ObservedObject var
    ///   - title: if nill it uses plural form of Child Entity name
    ///   - smallFont:
    ///   - predicate: if nil it uses defauls predicate
    ///   - keyPathParentToChildren:
    ///   - dashboard: a View above Child list
    ///   - editor: editor for Child
    init(
        for parent: Parent,
        title: String? = nil,
        smallFont: Bool = true,
        predicate: NSPredicate? = nil,
        keyPathParentToChildren: ReferenceWritableKeyPath<Parent, NSSet?>,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
        
    ) {
        self.parent = parent
        self.title = title ?? Child.plural
        self.smallFont = smallFont
        self.keyPathParentToChildren = keyPathParentToChildren
        self.dashboard = dashboard
        self.editor = editor
        
        if predicate == nil, type(of: parent) == Factory.self {
            let predicateToUse = Child.factoryPredicate(for: parent as! Factory)
            
            _entities = Child.defaultFetchRequest(with: predicateToUse)
        } else {
            _entities = Child.defaultFetchRequest(with: predicate)
        }
        
        _orphans = Child.defaultFetchRequest(with: Child.orphanPredicate)
    }
    
    @FetchRequest private var entities: FetchedResults<Child>
    @FetchRequest private var orphans: FetchedResults<Child>
    
    var body: some View {
        List {
            //  TextField("Search", text: $searchText)
            
            dashboard()
            
            if !orphans.isEmpty {
                GenericListSection(
                    header: "Orphans",
                    fetchRequest: _orphans,
                    smallFont: smallFont,
                    editor: editor
                )
                .foregroundColor(.systemRed)
            }
            
            GenericListSection(
                fetchRequest: _entities,
                smallFont: smallFont,
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

extension EntityListWithDashboard where Child: FactoryChild, Parent == Factory {
    
    init(
        for parent: Parent,
        title: String? = nil,
        smallFont: Bool = true,
        predicate: NSPredicate? = nil,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
    ) {
        self.init(
            for: parent,
            title: title,
            smallFont: smallFont,
            predicate: predicate,
            keyPathParentToChildren: Child.factoryToChildrenKeyPath,
            dashboard: dashboard,
            editor: editor)
    }
}

struct EntityListWithDashboard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EntityListWithDashboard(
                    for: Base.example,
                    title: "Not Offspringable: All Ingredients",
                    predicate: nil,
                    keyPathParentToChildren: \Base.recipes_
                ) {
                    Text("Dashboard goes here")
                } editor: { (ingredient: Ingredient) in
                    IngredientView(ingredient)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            
            NavigationView {
                EntityListWithDashboard(
                    for: Factory.example,
                    title: "Offspringable: All Buyers",
                    predicate: nil
                ) {
                    Text("Dashboard goes here")
                } editor: { (buyer: Buyer) in
                    BuyerEditor(buyer)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
