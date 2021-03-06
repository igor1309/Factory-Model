//
//  EntityNavigationLink.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct EntityLinkToList<T: Listable>: View where T.ManagedType == T {
    
    @EnvironmentObject private var settings: Settings
    
    private var destination: some View {
        List {
            GenericListSection(type: T.self, predicate: nil)
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

struct EntityLinkToList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Form {
                EntityLinkToList<Base>()
                EntityLinkToList<Product>()
                EntityLinkToList<Division>()
                EntityLinkToList<Employee>()
            }
            .navigationBarTitle("EntityLinkToList", displayMode: .inline)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
        .previewLayout(.fixed(width: 350, height: 400))
    }
}
