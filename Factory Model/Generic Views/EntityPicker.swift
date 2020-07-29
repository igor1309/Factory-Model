//
//  EntityPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import SwiftUI
import CoreData

typealias PickableEntity = Managed & Monikerable & Summarable & Validatable //& NSManagedObject

struct EntityPicker<T: PickableEntity & Sketchable>: View {
    @Environment(\.managedObjectContext) var context
    
    @Binding var selection: T?
    var icon: String? = nil
    var predicate: NSPredicate? = nil
    
    @State private var showList = false
    
    var body: some View {
        Button {
            showList = true
        } label: {
            if let icon = icon {
                Label(selection?.title ?? "...", systemImage: icon)
            } else {
                Text(selection?.title ?? "...")
            }
        }
        .sheet(isPresented: $showList) {
            EntityPickerList(selection: $selection, predicate: predicate)
                .environment(\.managedObjectContext, context)
        }
    }
}

struct EntityPickerList<T: PickableEntity & Sketchable>: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentation
    
    @Binding var selection: T?
    
    @FetchRequest private var entities: FetchedResults<T>
    
    init(
        selection: Binding<T?>,
        predicate: NSPredicate?
    ) {
        self._selection = selection
        _entities = FetchRequest(
            entity: T.entity(),
            sortDescriptors: T.defaultSortDescriptors,
            predicate: predicate
        )
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(entities, id: \.objectID) { entity in
                    Button {
                        selection = entity
                        presentation.wrappedValue.dismiss()
                    } label: {
                        ListRow(entity)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(T.entityName)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: CreateOrphanButton<T>())
        }
    }
}

