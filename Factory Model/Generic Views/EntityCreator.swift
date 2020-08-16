//
//  NewEntityCreator.swift
//  Factory Model
//
//  Created by Igor Malyarov on 01.08.2020.
//

import SwiftUI
import CoreData

struct EntityCreator<T: Managed & Validatable, Editor: View>: View where T.ManagedType == T {
    
    @Environment(\.managedObjectContext) private var context
    
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
        EntityList(request: request, isPresented: $isPresented, editor: editor)
            .onAppear {
                let entity = T.create(in: context)
                let objectID = entity.objectID
                let predicate = NSPredicate(format: "%K == %@", "objectID", objectID)
                request = T.defaultNSFetchRequest(with: predicate)
            }
    }
}

fileprivate struct EntityList<T: Managed & Validatable, Editor: View>: View where T.ManagedType == T {
    
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
                EditorWrapper(entity, isPresented: $isPresented, editor: editor)
            }
        }
    }
}

fileprivate struct EditorWrapper<T: Managed & Validatable, Editor: View>: View where T.ManagedType == T {
    
    @Environment(\.managedObjectContext) private var context
    
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
    
    var body: some View {
        List {
            editor(entity)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("New \(T.entityName)")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(entity.isValid ? "Save" : "NO SAVE") {
                    context.saveContext()
                    isPresented = false
                }
                //  MARK: - FINISH THIS
                //  disabling of button should be working!!
                //  .disabled(!entity.isValid)
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
