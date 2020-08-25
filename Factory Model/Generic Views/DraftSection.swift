//
//  DraftSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.08.2020.
//

import CoreData
import SwiftUI

struct DraftSection<T: NSManagedObject & Managed & Summarizable, U: Draft & Summarizable>: View {
    @Binding var isNewDraftActive: Bool
    @Binding var drafts: [U]
    
    var body: some View {
        Section(
            header: Text("New \(T.plural)")
        ) {
            Button {
                isNewDraftActive = true
            } label: {
                Label("Add \(T.entityName)", systemImage: T.plusButtonIcon)
                    .foregroundColor(T.color)
            }
            
            ForEach(drafts) { draft in
                ListRow(draft)
            }
            .onDelete(perform: delete)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        drafts.remove(atOffsets: offsets)
    }
}
