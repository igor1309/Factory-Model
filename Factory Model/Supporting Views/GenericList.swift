//
//  GenericList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI
import CoreData

struct GenericSection<T: NSManagedObject & Summarable & Validatable, Editor: View>: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var fetchRequest: FetchedResults<T>
    let editor: (T) -> Editor
    let title: String
    
    init(
        _ title: String,
        _ fetchRequest: FetchRequest<T>,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        self.title = title
        _fetchRequest = fetchRequest
        self.editor = editor
    }
    
    @State private var showDeleteAction = false
    
    var body: some View {
        Section(
            header: Text(title)
        ) {
            if fetchRequest.isEmpty {
                Text("No data to list")
            } else {
                ForEach(fetchRequest, id: \.objectID) { item in
                    NavigationLink(
                        destination: editor(item)
                    ) {
                        ListRow(item)
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
                                    message: Text("Do you really want to delete '\(item.title)'?\nThis cannot be undone."),
                                    buttons: [
                                        .destructive(Text("Yes, delete")) { delete(item) },
                                        .cancel()
                                    ]
                                )
                            }
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
    
    private func delete(_ item: T) {
        withAnimation {
            moc.delete(item)
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
