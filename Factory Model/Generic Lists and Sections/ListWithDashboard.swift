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
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var parent: NSManagedObject
    
    let title: String
    let smallFont: Bool
    let plusButton: () -> PlusButton
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    init(
        for parent: Parent,
        title: String? = nil,
        predicate: NSPredicate? = nil,
        smallFont: Bool = true,
        plusButton: @escaping () -> PlusButton,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
    ) {
        self.parent = parent
        self.title = title ?? Child.plural
        self.smallFont = smallFont
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
        // .navigationBarItems(trailing: plusButton())
        .toolbar { plusButton() }
    }
}


//  MARK: - FINISH THIS THIS EXTENSION CREATED TO COMPLETLY REMOVE EntityListWithDashboard
//  but there is a problem with PlusButton Type that cannot be infered

private extension ListWithDashboard where Child: FactoryTracable {
    init(
        for parent: Parent,
        title: String? = nil,
        predicate: NSPredicate? = nil,
        smallFont: Bool = true,
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
            title: title ?? Child.plural,
            predicate: predicateToUse,
            smallFont: smallFont,
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
        smallFont: Bool = true,
        predicate: NSPredicate? = nil,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
        
    ) {
        self.init(
            for: parent,
            title: title,
            predicate: predicate,
            smallFont: smallFont,
            keyPathParentToChildren: Child.offspringKeyPath,
            dashboard: dashboard,
            editor: editor)
    }
}

struct ListWithDashboard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            //  MARK: - есть ли варианты, когда Child: Monikerable & Managed & Summarizable & Sketchable & Orphanable НО НЕ FactoryTracable?
            
            //  MARK: - есть ли варианты, когда Child: Monikerable & Managed & Summarizable & Sketchable & Orphanable НО НЕ Offspringable??
            
            //  MARK: - not Offspringable
            NavigationView {
                ListWithDashboard(
                    for: Factory.example,
                    predicate: Department.factoryPredicate(for: Factory.example)
                ) {
                    CreateOrphanButton<Department>(systemName: Department.plusButtonIcon)
                } dashboard: {
                    Text("Dashboard goes here")
                } editor: { (department: Department) in
                    DepartmentView(department)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .previewLayout(.fixed(width: 350, height: 400))
            
            
            //  MARK: - FactoryTracable
            NavigationView {
                ListWithDashboard(
                    for: Factory.example,
                    predicate: Product.factoryPredicate(for: Factory.example)
                ) {
                    CreateOrphanButton<Product>(systemName: Product.plusButtonIcon)
                } dashboard: {
                    Text("Dashboard goes here")
                } editor: { (product: Product) in
                    ProductView(product)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .previewLayout(.fixed(width: 350, height: 400))
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
