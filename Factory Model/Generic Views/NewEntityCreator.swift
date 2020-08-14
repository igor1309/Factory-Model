//
//  NewEntityCreator.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI
import CoreData

struct NewEntityCreator<T: Managed & Validatable, Editor: View>: View where T.ManagedType == T {
    @Environment(\.managedObjectContext) var context
    
    @Binding var isPresented: Bool
    let editor: (T) -> Editor
    
    init(
        isPresented: Binding<Bool>,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        _isPresented = isPresented
        self.editor = editor
    }
    
    @State private var url: URL? = nil
    
    var body: some View {
        NavigationView {
            List {
                NewEntityList(
                    entitySearch: EntitySearch(url: url, context: context),
                    isPresented: $isPresented
                ) { (entity: T) in
                    editor(entity)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("New \(T.entityName)")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            let entity = T.create(in: context)
            url = entity.objectID.uriRepresentation()
        }
        .onDisappear {
            url = nil
        }
    }
}

fileprivate struct NewEntityList<T: Managed & Validatable, Editor: View>: View where T.ManagedType == T {
    @Binding var isPresented: Bool
    let editor: (T) -> Editor
    
    init(
        entitySearch: EntitySearch,
        isPresented: Binding<Bool>,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        _request = T.defaultFetchRequest(with: entitySearch.predicate)
        _isPresented = isPresented
        self.editor = editor
    }
    
    @FetchRequest private var request: FetchedResults<T>
    
    var body: some View {
        ForEach(request, id: \.objectID) { entity in
            EditorWrapper(entity, isPresented: $isPresented) { entity in
                editor(entity)//SalesEditorCore(entity)
            }
        }
    }
}

fileprivate struct EditorWrapper<T: NSManagedObject & Managed & Validatable, Editor: View>: View {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var entity: T
    
    @Binding var isPresented: Bool
    
    let editor: (T) -> Editor
    
    init(
        _ entity: T,
        isPresented: Binding<Bool>,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        self.entity = entity
        _isPresented = isPresented
        self.editor = editor
    }

    @ViewBuilder var header: some View {
        if entity.isValid {
            Text("Can save new \(T.entityName)!")
                .foregroundColor(.secondary)
        } else {
            Text("ERROR: Fill or choose all parameters.")
                .foregroundColor(.systemRed)
        }
    }
    
    var body: some View {
        Group {
            editor(entity)//SalesEditorCore(entity)
            
            Section(
                header: header
            ) {
                HStack {
                    Spacer()
                    
                    Button("Discard") {
                        context.delete(entity)
                        isPresented = false
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    Spacer()
                    
                    Button("Save") {
                        context.saveContext()
                        isPresented = false
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(!entity.isValid)
                    
                    Spacer()
                }
                .foregroundColor(.accentColor)
            }
        }
    }
}

fileprivate struct EntitySearch {
    var url: URL?
    let context: NSManagedObjectContext
    
    var predicate: NSPredicate {
        if let url = url,
           let objectID =
            context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) {
            return NSPredicate(format: "%K == %@", "objectID", objectID)
        } else {
            return .none
        }
    }
}

