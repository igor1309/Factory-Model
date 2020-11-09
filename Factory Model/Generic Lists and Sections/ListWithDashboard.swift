//
//  ListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

typealias Dashboardable = Monikerable & Managed & Summarizable & Sketchable & Orphanable

struct ListWithDashboard<
    Child: Dashboardable,
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
        .navigationBarItems(trailing: plusButton())
        //        .toolbar { plusButton() }
    }
}


//  MARK: - FINISH THIS THIS EXTENSION CREATED TO COMPLETLY REMOVE EntityListWithDashboard
//  but there is a problem with PlusButton Type that cannot be infered

/// For `FactoryTracable` Types it's possible to construct `PlusButton` using `factoryPredicate` as default
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

/// This init for `Offspringable` types with Factory as parent: can get keyPathParentToChildren from Offspringable conformance
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
    
    
    //  MARK: - checking ListWithDashboard signatures - looking for conforming Entities (Types)
    
    private struct TestingListWithDashboard {
        struct Test1<T: Dashboardable> {}
        struct Testing1 {
            let base = Test1<Base>()
            let buyer = Test1<Buyer>()
            let department = Test1<Department>()
            let division = Test1<Division>()
            let equipment = Test1<Equipment>()
            let expenses = Test1<Expenses>()
            //let factory = Test1<Factory>() // Type 'Factory' does not conform to protocol 'Orphanable'
            let ingredient = Test1<Ingredient>()
            let recipe = Test1<Recipe>()
            let packaging = Test1<Packaging>()
            let product = Test1<Product>()
            let sales = Test1<Sales>()
            let utility = Test1<Utility>()
            let employee = Test1<Employee>()
        }
        
        struct Test2<T: Dashboardable & FactoryTracable> {}
        struct Testing2 {
            let base = Test2<Base>()
            let buyer = Test2<Buyer>()
            let department = Test2<Department>()
            let division = Test2<Division>()
            let equipment = Test2<Equipment>()
            let expenses = Test2<Expenses>()
            // let factory = Test2<Factory>() // Type 'Factory' does not conform to protocol 'Orphanable' and protocol 'FactoryTracable'
            let ingredient = Test2<Ingredient>()
            // let recipe = Test2<Recipe>()     // Type 'Recipe' does not conform to protocol 'FactoryTracable'
            let packaging = Test2<Packaging>()
            let product = Test2<Product>()
            let sales = Test2<Sales>()
            // let utility = Test2<Utility>()   //Type 'Utility' does not conform to protocol 'FactoryTracable'
            let employee = Test2<Employee>()
        }
        
        struct Test3<T: Dashboardable & FactoryTracable & Offspringable> {}
        struct Testing3 {
            // let base = Test3<Base>()    // Type 'Base' does not conform to protocol 'Offspringable'
            let buyer = Test3<Buyer>()
            // let department = Test3<Department>()    // Type 'Department' does not conform to protocol 'Offspringable'
            let division = Test3<Division>()
            let equipment = Test3<Equipment>()
            let expenses = Test3<Expenses>()
            // let factory = Test3<Factory>() Type 'Factory' does not conform to protocol 'Orphanable'
            // let ingredient = Test3<Ingredient>()    // Type 'Ingredient' does not conform to protocol 'Offspringable'
            //let recipe = Test3<Recipe>()     Type 'Recipe' does not conform to protocol 'FactoryTracable'
            // let packaging = Test3<Packaging>()  // Type 'Packaging' does not conform to protocol 'Offspringable'
            // let product = Test3<Product>()  // Type 'Product' does not conform to protocol 'Offspringable'
            // let sales = Test3<Sales>()  // Type 'Sales' does not conform to protocol 'Offspringable'
            // let utility = Test3<Utility>()   Type 'Utility' does not conform to protocol 'FactoryTracable'
            // let employee = Test3<Employee>()    // Type 'Employee' does not conform to protocol 'Offspringable'
        }
    }
    
    
    static var previews: some View {
        Group {
            
            //  MARK: - есть ли варианты, когда Child: Monikerable & Managed & Summarizable & Sketchable & Orphanable НО НЕ FactoryTracable? - yes, Factory
            
            //  MARK: - есть ли варианты, когда Child: Monikerable & Managed & Summarizable & Sketchable & Orphanable НО НЕ Offspringable?? - yes, see TestingListWithDashboard
            
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
