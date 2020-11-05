//
//  EntityNavigationLink.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct EntityLinkToList<T: Managed & Monikerable & Summarizable, Editor: View>: View where T.ManagedType == T {
    
    @EnvironmentObject var settings: Settings
    
    var editor: (T) -> Editor
    
    init(@ViewBuilder editor: @escaping (T) -> Editor) {
        self.editor = editor
    }
    
    private var destination: some View {
        List {
            GenericListSection(
                type: T.self,
                predicate: nil,
                in: settings.period
            ) { (entity: T) in
                editor(entity)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            Label(T.plural, systemImage: T.icon)
                .foregroundColor(T.color)
        }
    }
}
