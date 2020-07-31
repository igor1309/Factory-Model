//
//  AllBuyersList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct AllBuyersList: View {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
    }
    
    var old: some View {
        ListWithDashboard(
            title: "All Buyers",
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Buyer.factory), factory
            )
        ) {
            CreateChildButton(
                systemName: "cart.badge.plus",
                childType: Buyer.self,
                parent: factory,
                keyPath: \Factory.buyers_
            )
        } dashboard: {
            
        } editor: { (buyer: Buyer) in
            BuyerView(buyer)
        }
    }
    
    var body: some View {
        AllEntityList(
            for: factory,
            title: "All Buyers!!!!",
            systemName: "cart.badge.plus",
            predicate: nil,// if nil use default!!
            keyPathParentToChildren: \Factory.buyers_
        ) {
            
        } editor: { (buyer: Buyer) in
            BuyerView(buyer)
        }
        
    }
}

import CoreData
struct AllEntityList<
    Child: Monikerable & Managed & Summarizable & Validatable & Sketchable & Orphanable,
    Parent: NSManagedObject,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var parent: Parent
    
    let title: String
    let systemName: String
    let useSmallerFont: Bool
    let keyPathParentToChildren: ReferenceWritableKeyPath<Parent, NSSet?>
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    @FetchRequest private var entities: FetchedResults<Child>
    @FetchRequest private var orphansFetchRequest: FetchedResults<Child>
    
    //  @State private var searchText = ""
    
    init(
        for parent: Parent,
        title: String? = nil,
        systemName: String,
        useSmallerFont: Bool = true,
        predicate: NSPredicate? = nil,
        keyPathParentToChildren: ReferenceWritableKeyPath<Parent, NSSet?>,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
        
    ) {
        self.parent = parent
        self.title = title == nil ? Child.plural() : title!
        self.systemName = systemName
        self.useSmallerFont = useSmallerFont
        //  MARK: - FINISH THIS if predicate is nill use defaultPredicate!!
        self.keyPathParentToChildren = keyPathParentToChildren
        self.dashboard = dashboard
        self.editor = editor
        _entities = Child.defaultFetchRequest(with: predicate)
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
        .navigationTitle(title)
        .navigationBarItems(
            trailing:
                CreateChildButton(
                    systemName: systemName,
                    childType: Child.self,
                    parent: parent,
                    keyPath: keyPathParentToChildren
                )
        )
    }
}
