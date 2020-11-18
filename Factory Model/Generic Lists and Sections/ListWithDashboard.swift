//
//  ListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

typealias Dashboardable = Listable & Sketchable & Orphanable

extension ListWithDashboard where Child: Dashboardable & FactoryTracable,
                                  PlusButton == CreateChildButton<Child, Factory> {
    
    /// for direct Factory children (Base, Buyer, Division, Expenses, Equipment)
    /// Creates a View with Dashboard above the Child List with Plus Button in navigation bar. Plus Button icon is taken from Summarizable protocol conformance.
    /// - Parameters:
    ///   - factory: @ObservedObject var, direct parent
    ///   - title: optional, it uses plural form of Child Entity name if nil
    ///   - smallFont:
    ///   - predicate: if nil it uses defauls predicate
    ///   - dashboard: a View above Child list
    init(
        for factory: Factory,
        title: String? = nil,
        smallFont: Bool = true,
        predicate: NSPredicate? = nil,
        keyPathToParent: ReferenceWritableKeyPath<Child, Factory?>,
        @ViewBuilder dashboard: @escaping () -> Dashboard
    ) {
        self.title = title ?? Child.plural
        self.smallFont = smallFont
        self.dashboard = dashboard

        self.plusButton = {
            CreateChildButton(systemName: Child.plusButtonIcon, parent: factory, keyPathToParent: keyPathToParent)
        }
        
        if let predicate = predicate {
            _entities = Child.defaultFetchRequest(with: predicate)
        } else {
            let predicateToUse = Child.factoryPredicate(for: factory)
            _entities = Child.defaultFetchRequest(with: predicateToUse)
        }
        
        _orphans = Child.defaultFetchRequest(with: Child.orphanPredicate)
    }
}

struct ListWithDashboard<
    Child: Dashboardable,
    PlusButton: View,
    Dashboard: View
>: View where Child.ManagedType == Child {
    
    @EnvironmentObject private var settings: Settings
    
    let title: String
    let smallFont: Bool
    let plusButton: () -> PlusButton
    let dashboard: () -> Dashboard
    
    /// for immediate Factory children use FactoryChildrenListWithDashboard
    init(
        childType: Child.Type,
        title: String? = nil,
        smallFont: Bool = true,
        predicate: NSPredicate? = nil,
        plusButton: @escaping () -> PlusButton,
        @ViewBuilder dashboard: @escaping () -> Dashboard
    ) {
        self.title = title ?? Child.plural
        self.smallFont = smallFont
        self.plusButton = plusButton
        self.dashboard = dashboard
        
        _entities = Child.defaultFetchRequest(with: predicate)
        _orphans = Child.defaultFetchRequest(with: Child.orphanPredicate)
    }
    
    @FetchRequest private var entities: FetchedResults<Child>
    @FetchRequest private var orphans: FetchedResults<Child>
    
    //  @State private var searchText = ""
    
    var body: some View {
        
        List {
            //  TextField("Search", text: $searchText)
            
            dashboard()
            
            if !orphans.isEmpty {
                GenericListSection(header: "Orphans", fetchRequest: _orphans, smallFont: smallFont)
                    .foregroundColor(.systemRed)
            }
            
            GenericListSection(fetchRequest: _entities, smallFont: smallFont)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarItems(trailing: plusButton())
    }
}

struct ListWithDashboard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //  MARK: direct Factory Child: Base
            NavigationView {
                ListWithDashboard(for: Factory.example, keyPathToParent: \Base.factory) {
                    Text("Dashboard goes here")
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .previewLayout(.fixed(width: 350, height: 600))
            
            
            //  MARK: non-direct child
            NavigationView {
                ListWithDashboard(
                    childType: Product.self,
                    predicate: Product.factoryPredicate(for: Factory.example)
                ) {
                    CreateNewEntityButton<Product>()
                } dashboard: {
                    Text("Dashboard goes here")
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
