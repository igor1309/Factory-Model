//
//  EntityCreator.swift
//  Factory Model
//
//  Created by Igor Malyarov on 15.08.2020.
//

import SwiftUI
import CoreData

struct EntityCreator<T: Managed & Validatable, Editor: View>: View where T.ManagedType == T {
    
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
    
    @State private var request = T.defaultNSFetchRequest(with: nil)
    
    var body: some View {
        EditorWrapper(
            request: request,
            isPresented: $isPresented
        ) { (entity: T) in
            editor(entity)
        }
        .onAppear {
            let entity = T.create(in: context)
            let objectID = entity.objectID
            let predicate = NSPredicate(format: "%K == %@", "objectID", objectID)
            request = T.defaultNSFetchRequest(with: predicate)
        }
    }
}

fileprivate struct EditorWrapper<T: Managed & Validatable, Editor: View>: View where T.ManagedType == T {
    
    @Environment(\.managedObjectContext) var context
    
    @Binding var isPresented: Bool
    let editor: (T) -> Editor
    
    init(
        request: NSFetchRequest<T>,
        isPresented: Binding<Bool>,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        _request = FetchRequest(fetchRequest: request)
        _isPresented = isPresented
        self.editor = editor
    }
    
    @FetchRequest private var request: FetchedResults<T>
    
    var body: some View {
        NavigationView {
            ForEach(request, id: \.objectID) { entity in
                List {
                    Text("entity \(entity.isValid ? "isValid" : "is NOT Valid")")
                    editor(entity)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("New \(T.entityName)")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            context.saveContext()
                            isPresented = false
                        }
                        .disabled(!entity.isValid)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Discard") {
                            context.delete(entity)
                            isPresented = false
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

