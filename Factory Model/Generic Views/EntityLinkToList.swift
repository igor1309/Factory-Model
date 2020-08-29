//
//  EntityNavigationLink.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct EntityLinkToList<T: Managed & Monikerable & Summarizable, Editor: View>: View where T.ManagedType == T {
    
    var editor: (T) -> Editor
    let period: Period
    
    init(in period: Period, @ViewBuilder editor: @escaping (T) -> Editor) {
        self.period = period
        self.editor = editor
    }
    
    var body: some View {
        NavigationLink(
            destination:
                List {
                    GenericListSection(
                        type: T.self,
                        predicate: nil,
                        in: period
                    ) { (entity: T) in
                        editor(entity)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitleDisplayMode(.inline)
        ) {
            Label(T.plural, systemImage: T.icon)
                .foregroundColor(T.color)
        }
    }
}
