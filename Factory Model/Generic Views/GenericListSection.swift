//
//  GenericList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI
import CoreData

typealias Listable = Monikerable & Summarizable & Managed

struct GenericListSection<T: Listable, Editor: View>: View where T.ManagedType == T {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var fetchRequest: FetchedResults<T>
    
    let editor: (T) -> Editor
    let useSmallerFont: Bool
    let header: String
    
    init(
        header: String? = T.plural(),
        fetchRequest: FetchRequest<T>,
        useSmallerFont: Bool = true,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        self.header = header == nil ? T.plural() : header!
        _fetchRequest = fetchRequest
        self.editor = editor
        self.useSmallerFont = useSmallerFont
    }
    
    init(
        header: String? = T.plural(),
        type: T.Type,
        predicate: NSPredicate?,
        useSmallerFont: Bool = true,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        self.header = header == nil ? T.plural() : header!
        self.editor = editor
        self.useSmallerFont = useSmallerFont
        _fetchRequest = T.defaultFetchRequest(with: predicate)
    }
    
    var body: some View {
        Section(
            header: Text(header)
        ) {
            if fetchRequest.isEmpty {
                Text("No data to list")
                    .foregroundColor(.systemTeal)
                    .font(.subheadline)
            } else {
                ForEach(fetchRequest, id: \.objectID) { entity in
                    NavigationLink(
                        destination: editor(entity)
                    ) {
                        EntityRowWithAction(entity, useSmallerFont: useSmallerFont)
                    }
                }
            }
        }
        //  MARK: - FINISH THIS удаление не-сиротских объектов лучше не допускать без подтверждения
        //        .onDelete(perform: remove)
        .onDisappear {
            moc.saveContext()
        }
    }
    
    private func remove(at offsets: IndexSet) {
        //  MARK: - FINISH THIS удаление не-сиротских объектов лучше не допускать без подтверждения
        for index in offsets {
            let item = fetchRequest[index]
            moc.delete(item)
        }
        moc.saveContext()
    }
}

fileprivate struct EntityRowWithAction<T: Listable>: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var entity: T
    
    var useSmallerFont: Bool
    
    init(_ entity: T, useSmallerFont: Bool = true) {
        self.entity = entity
        self.useSmallerFont = useSmallerFont
    }
    
    @State private var showDeleteAction = false
    
    var body: some View {
        EntityRow(entity, useSmallerFont: useSmallerFont)
            .contextMenu {
                Button {
                    showDeleteAction = true
                } label: {
                    Image(systemName: "trash.circle")
                    Text("Delete")
                }
            }
            .actionSheet(isPresented: $showDeleteAction) {
                ActionSheet(
                    title: Text("Delete?".uppercased()),
                    message: Text("Do you really want to delete '\(entity.title)'?\nThis cannot be undone."),
                    buttons: [
                        .destructive(Text("Yes, delete")) { delete(entity) },
                        .cancel()
                    ]
                )
            }
    }
    
    private func delete(_ entity: T) {
        withAnimation {
            moc.delete(entity)
            moc.saveContext()
        }
    }
}
