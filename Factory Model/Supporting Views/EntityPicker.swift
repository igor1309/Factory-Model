//
//  EntityPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import SwiftUI
import CoreData

struct EntityPicker<T: PickableEntity>: View {
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
            EntityPickerTable(selection: $selection, predicate: predicate)
                .environment(\.managedObjectContext, context)
        }
    }
}

typealias PickableEntity = Managed & Monikerable & Summarable & Validatable //& NSManagedObject

struct EntityPickerTable<T: PickableEntity>: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentation
    
    @Binding var selection: T?
//    var context: NSManagedObjectContext
    var predicate: NSPredicate?
    
    @FetchRequest private var entities: FetchedResults<T>
    
    init(
        selection: Binding<T?>,
//        context: NSManagedObjectContext,
        predicate: NSPredicate?
    ) {
        self._selection = selection
//        self.context = context
        self.predicate = predicate
        _entities = FetchRequest(
            entity: T.entity(),
            sortDescriptors: [],
            predicate: predicate
        )
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(entities, id: \.objectID) { entity in
                    Button {
                        self.selection = entity
                        presentation.wrappedValue.dismiss()
                    } label: {
                        ListRow(entity)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(T.entityName)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: plusButton)
        }
    }
    
    private var plusButton: some View {
        Button {
            let entity = T.create(in: context)
            entity.name = " New"
            context.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
