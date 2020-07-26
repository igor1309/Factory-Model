//
//  GenericList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 26.07.2020.
//

import SwiftUI
import CoreData

struct GenericList<T: NSManagedObject & Summarable & Validatable, Editor: View>: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var fetchRequest: FetchedResults<T>
    let editor: (T) -> Editor
    
    init(
        _ fetchRequest: FetchRequest<T>,
        @ViewBuilder editor: @escaping (T) -> Editor
    ) {
        _fetchRequest = fetchRequest
        self.editor = editor
    }
    
    var body: some View {
        ForEach(fetchRequest, id: \.objectID) { item in
            NavigationLink(
                destination: editor(item)
            ) {
                ListRow(item)
            }
        }
        .onDelete(perform: remove)
        .onDisappear { moc.saveContext() }
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
