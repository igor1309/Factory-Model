//
//  ListWithDashboard.swift
//  Factory Model
//
//  Created by Igor Malyarov on 28.07.2020.
//

import SwiftUI
import CoreData

struct ListWithDashboard<
    Child: Monikerable & Managed & Summarizable & Validatable & Sketchable & Orphanable,
    PlusButton: View,
    Dashboard: View,
    Editor: View
>: View where Child.ManagedType == Child {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var entities: FetchedResults<Child>
    @FetchRequest private var childFetchRequest: FetchedResults<Child>

    //  @State private var searchText = ""
    
    let title: String
    let useSmallerFont: Bool
    let plusButton: () -> PlusButton
    let dashboard: () -> Dashboard
    let editor: (Child) -> Editor
    
    init(
        title: String? = nil,
        predicate: NSPredicate? = nil,
        useSmallerFont: Bool = true,
        plusButton: @escaping () -> PlusButton,
        @ViewBuilder dashboard: @escaping () -> Dashboard,
        @ViewBuilder editor: @escaping (Child) -> Editor
    ) {
        self.title = title == nil ? Child.plural() : title!
        self.useSmallerFont = useSmallerFont
        self.plusButton = plusButton
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
        .navigationTitle(title)
        .navigationBarItems(trailing: plusButton())
    }
}
