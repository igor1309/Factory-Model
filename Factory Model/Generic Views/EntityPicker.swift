//
//  EntityPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import SwiftUI
import CoreData

typealias PickableEntity = Managed & Monikerable & Summarizable //& NSManagedObject

struct EntityPicker<T: PickableEntity & Sketchable>: View {
    @Environment(\.managedObjectContext) private var context
    
    @Binding var selection: T?
    var icon: String? = nil
    var predicate: NSPredicate? = nil
    
    init(
        selection: Binding<T?>,
        icon: String? = nil,
        predicate: NSPredicate? = nil
    ) {
        self._selection = selection
        self.icon = icon
        self.predicate = predicate
    }
    
    @State private var showSheet = false
    
    @ViewBuilder
    private var label: some View {
        if let icon = icon {
            Label(selection?.title ?? "Select \(T.entityName)", systemImage: icon)
        } else {
            Text(selection?.title ?? "Select \(T.entityName)")
        }
    }
    
    var body: some View {
        Button {
            showSheet = true
        } label: {
            if selection == nil {
                label.foregroundColor(.systemRed)
            } else {
                label
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: {
            //  MARK: - а надо ли? ведь это @Binding
            if selection != nil {
                selection!.objectWillChange.send()
            }
        }) {
            EntityPickerSheet(
                selection: $selection,
                predicate: predicate
            )
            .environment(\.managedObjectContext, context)
        }
    }
}

fileprivate struct EntityPickerSheet<T: PickableEntity & Sketchable>: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentation
    
    @Binding var selection: T?
    
    @FetchRequest private var entities: FetchedResults<T>
    
    init(
        selection: Binding<T?>,
        predicate: NSPredicate?
    ) {
        _selection = selection
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
                        EntityRow(entity)
                            .foregroundColor(selection == entity ? .systemOrange : .accentColor)
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

