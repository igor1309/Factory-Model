//
//  EntityNavigationLink.swift
//  Factory Model
//
//  Created by Igor Malyarov on 20.08.2020.
//

import SwiftUI

struct EntityLinkToList<T: Listable, Editor: View>: View where T.ManagedType == T {
    
    @EnvironmentObject var settings: Settings
    
    var editor: (T) -> Editor
    
    init(@ViewBuilder editor: @escaping (T) -> Editor) {
        self.editor = editor
    }
    
    private var destination: some View {
        List {
            GenericListSection(type: T.self, predicate: nil, editor: editor)
//            GenericListSection(
//                type: T.self,
//                predicate: nil
//            ) { (entity: T) in
//                editor(entity)
//            }
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
                EntityLinkToList { (base: Base) in
                    BaseEditor(base)
                }
                EntityLinkToList { (product: Product) in
                    ProductEditor(product)
                }
                EntityLinkToList { (division: Division) in
                    DivisionEditor(division)
                }
                EntityLinkToList { (employee: Employee) in
                    EmployeeEditor(employee)
                }
            }
            .navigationBarTitle("EntityLinkToList", displayMode: .inline)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .environment(\.colorScheme, .dark)
        .previewLayout(.fixed(width: 350, height: 350))
    }
}
