//
//  ListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

struct ListWithDashboard<
    Child: Monikerable & Managed & Summarizable & Sketchable & Orphanable,
    Parent: NSManagedObject,
    PlusButton: View,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var parent: NSManagedObject
    
    let title: String
    let useSmallerFont: Bool
    let period: Period
    let plusButton: () -> PlusButton
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    init(
        for parent: Parent,
        title: String? = nil,
        predicate: NSPredicate? = nil,
        useSmallerFont: Bool = true,
        in period: Period,
        plusButton: @escaping () -> PlusButton,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
    ) {
        self.parent = parent
        self.title = title == nil ? Child.plural : title!
        self.useSmallerFont = useSmallerFont
        self.period = period
        self.plusButton = plusButton
        self.dashboard = dashboard
        self.editor = editor
        _entities = Child.defaultFetchRequest(with: predicate)
        _orphansFetchRequest = Child.defaultFetchRequest(with: Child.orphanPredicate)
    }
    
    @FetchRequest private var entities: FetchedResults<Child>
    @FetchRequest private var orphansFetchRequest: FetchedResults<Child>
    
    //  @State private var searchText = ""
    
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
        .navigationBarItems(trailing: plusButton())
    }
}


//  MARK: - FINISH THIS THIS EXTENSION CREATED TO COMPLETLY REMOVE EntityListWithDashboard
//  but there is a problem with PlusButton Type that cannot be infered

private extension ListWithDashboard where Child: FactoryTracable {
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
        let predicateToUse: NSPredicate
        if predicate == nil, type(of: parent) == Factory.self {
            predicateToUse = Child.factoryPredicate(for: parent as! Factory )
            
        } else {
            predicateToUse = predicate!
        }
        
        let plusButton: () -> PlusButton = {
            CreateChildButton(
                systemName: Child.plusButtonIcon,
                childType: Child.self,
                parent: parent,
                keyPath: keyPathParentToChildren
            ) as! PlusButton
        }
        
        self.init(
            for: parent,
            title: title == nil ? Child.plural : title!,
            predicate: predicateToUse,
            useSmallerFont: useSmallerFont,
            in: period,
            plusButton: plusButton,
            dashboard: dashboard,
            editor: editor
        )
    }
}


//  MARK: - FINISH THIS THIS EXTENSION CREATED TO COMPLETLY REMOVE EntityListWithDashboard
//  but there is a problem with PlusButton Type that cannot be infered
private extension ListWithDashboard where Child: FactoryTracable & Offspringable, Parent == Factory {
    
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
