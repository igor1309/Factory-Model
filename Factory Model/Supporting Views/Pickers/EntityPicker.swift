//
//  EntityPicker.swift
//  Factory Model
//
//  Created by Igor Malyarov on 27.07.2020.
//

import SwiftUI
import CoreData

typealias PickableEntity = Managed & Monikerable & Summarizable //& NSManagedObject

struct EntityPickerSection<T: PickableEntity & Sketchable>: View {
    @Binding var selection: T?

    let predicate: NSPredicate? = nil
    let period: Period
    
    var body: some View {
        Section(
            header: Text(T.entityName)
        ) {
            EntityPicker(selection: $selection, icon: T.icon, predicate: predicate, period: period)
                .foregroundColor(selection == nil ? .systemRed : .accentColor)
        }
    }
}

struct EntityPicker<T: PickableEntity & Sketchable>: View {
    @Environment(\.managedObjectContext) private var context
    
    @Binding var selection: T?
    var icon: String? = nil
    var predicate: NSPredicate? = nil
    let period: Period
    
    @State private var showSheet = false
    
    @ViewBuilder
    private var label: some View {
        if let icon = icon {
            Label(selection?.title(in: period) ?? "Select \(T.entityName)", systemImage: icon)
        } else {
            Text(selection?.title(in: period) ?? "Select \(T.entityName)")
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
                predicate: predicate,
                in: period
            )
            .environment(\.managedObjectContext, context)
        }
    }
}

fileprivate struct EntityPickerSheet<T: PickableEntity & Sketchable>: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentation
    
    @Binding var selection: T?
    
    let period: Period
    
    @FetchRequest private var entities: FetchedResults<T>
    
    init(
        selection: Binding<T?>,
        predicate: NSPredicate?,
        in period: Period
    ) {
        _selection = selection
        _entities = FetchRequest(
            entity: T.entity(),
            sortDescriptors: T.defaultSortDescriptors,
            predicate: predicate
        )
        self.period = period
    }
    
    var body: some View {
        NavigationView {
            List {
                if entities.isEmpty {
                    Text("No \(T.plural) to select from. Tap + to add one.")
                } else {
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
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(T.entityName)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: CreateOrphanButton<T>())
        }
    }
}


struct EntityPicker_Previews: PreviewProvider {
    @StateObject static var base = Base.example
    
    static var previews: some View {
        NavigationView {
            Form {
                EntityPicker(selection: .constant(base), icon: "envelope.arrow.triangle.branch", predicate: nil, period: .month())
                
                EntityPickerSection<Base>(selection: .constant(base), period: .month())
            }
        }
        .environment(\.colorScheme, .dark)
    }
}
