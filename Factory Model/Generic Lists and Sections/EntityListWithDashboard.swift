//
//  EntityListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 31.07.2020.
//

import SwiftUI
import CoreData

struct EntityListWithDashboard<
    Child: Dashboardable & FactoryChild,
    Parent: NSManagedObject,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var parent: Parent
    
    let title: String
    let smallFont: Bool
    let keyPathToParent: ReferenceWritableKeyPath<Child, Parent?>
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    /// Creates a View with Dashboard above the Child List with Plus Button in navigation bar. Plus Button icon is taken from Summarizable protocol conformance.
    /// - Parameters:
    ///   - parent: @ObservedObject var
    ///   - title: if nill it uses plural form of Child Entity name
    ///   - smallFont:
    ///   - predicate: if nil it uses defauls predicate
    ///   - dashboard: a View above Child list
    init(
        for parent: Parent,
        title: String? = nil,
        smallFont: Bool = true,
        predicate: NSPredicate? = nil,
        keyPathToParent: ReferenceWritableKeyPath<Child, Parent?>,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
    ) {
        self.parent = parent
        self.title = title ?? Child.plural
        self.smallFont = smallFont
        self.keyPathToParent = keyPathToParent
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
    
    //  @State private var searchText = ""
    
    private func createChildButton() -> some View {
        CreateChildButton(
            systemName: Child.plusButtonIcon,
            childType: Child.self,
            parent: parent,
            keyPathToParent: keyPathToParent
        )
    }
    
    var body: some View {
        
        List {
            //  TextField("Search", text: $searchText)
            
            dashboard()
            
            if !orphans.isEmpty {
                GenericListSection(header: "Orphans", fetchRequest: _orphans, smallFont: smallFont, editor: editor)
                .foregroundColor(.systemRed)
            }
            
            GenericListSection(fetchRequest: _entities, smallFont: smallFont, editor: editor)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: createChildButton())
    }
}

struct EntityListWithDashboard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EntityListWithDashboard(
                for: Factory.example,
                title: "Offspringable: All Buyers",
                predicate: nil,
                keyPathToParent: \Buyer.factory
            ) {
                Text("Dashboard goes here")
            } editor: { (buyer: Buyer) in
                BuyerEditor(buyer)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
