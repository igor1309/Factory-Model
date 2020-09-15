//
//  GenericList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI
import CoreData

typealias Listable = Managed & Monikerable & Summarizable

struct GenericListSection<T: Listable, Editor: View>: View where T.ManagedType == T {
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest private var fetchRequest: FetchedResults<T>
    
    let editor: (T) -> Editor
    let useSmallerFont: Bool
    let header: String
    let period: Period
    
    init(
        header: String? = T.plural,
        fetchRequest: FetchRequest<T>,
        useSmallerFont: Bool = true,
        in period: Period,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        self.header = header ?? T.plural
        _fetchRequest = fetchRequest
        self.editor = editor
        self.useSmallerFont = useSmallerFont
        self.period = period
    }
    
    init(
        header: String? = T.plural,
        type: T.Type,
        predicate: NSPredicate?,
        useSmallerFont: Bool = true,
        in period: Period,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        self.header = header ?? T.plural
        self.editor = editor
        self.useSmallerFont = useSmallerFont
        self.period = period
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
                        EntityRowWithAction(entity, useSmallerFont: useSmallerFont, in: period)
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
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var entity: T
    
    let useSmallerFont: Bool
    let period: Period
    
    init(_ entity: T, useSmallerFont: Bool = true, in period: Period) {
        self.entity = entity
        self.useSmallerFont = useSmallerFont
        self.period = period
    }
    
    @State private var showDeleteAction = false
    
    var body: some View {
        EntityRow(entity, useSmallerFont: useSmallerFont, in: period)
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
                    message: Text("Do you really want to delete '\(entity.title(in: period))'?\nThis cannot be undone."),
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
