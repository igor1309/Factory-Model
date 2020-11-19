//
//  DraftSection.swift
//  Factory Model
//
//  Created by Igor Malyarov on 19.08.2020.
//

import CoreData
import SwiftUI

struct DraftSection<T: NSManagedObject & Managed & Summarizable, U: Draft & Summarizable>: View {
    
    @EnvironmentObject private var settings: Settings
    
    @Binding var isNewDraftActive: Bool
    @Binding var drafts: [U]
    
    var body: some View {
        Section(
            header: Text("New \(T.plural)")
        ) {
            Button {
                let haptics = Haptics()
                haptics.haptic()
                
                withAnimation {
                    isNewDraftActive = true
                }
            } label: {
                Label("Add \(T.entityName)", systemImage: T.plusButtonIcon)
                    .foregroundColor(T.color)
            }
            
            ForEach(drafts) { draft in
                ListRow(draft, period: settings.period)
            }
            .onDelete(perform: delete)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        drafts.remove(atOffsets: offsets)
    }
}

struct DraftSection_Previews: PreviewProvider {
    @State static private var isNewDraftActive = false
    @State static private var recipeDrafts = [RecipeDraft.example]
    @State static private var salesDrafts = [SalesDraft.example]
    @State static private var employeeDrafts = [EmployeeDraft.example]
    
    static var previews: some View {
        NavigationView {
            List {
                DraftSection<Ingredient, RecipeDraft>(isNewDraftActive: $isNewDraftActive, drafts: $recipeDrafts)
                
                DraftSection<Sales, SalesDraft>(isNewDraftActive: $isNewDraftActive, drafts: $salesDrafts)

                DraftSection<Employee, EmployeeDraft>(isNewDraftActive: $isNewDraftActive, drafts: $employeeDrafts)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
    }
}
