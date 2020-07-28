//
//  BaseList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct BaseList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var bases: FetchedResults<Base>
    
    //    @ObservedObject
    var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
        _bases = Base.defaultFetchRequest(for: factory)
    }
    
    var body: some View {
        List {
            
            Text("TBD: Ingredients")
                .foregroundColor(.systemRed)
            
//            Section(
//                header: Text("Base Groups"),
//                footer: Text("TBD: How to change to fetch request?")
//            ) {
//                ForEach(factory.baseGroupsAsRows) { baseGroup in
//                    NavigationLink(
//                        destination: BaseGroupList(group: baseGroup.title, at: factory)
//                    ) {
//                        ListRow(baseGroup)
//                    }
//                }
//            }
            
            Group {
                ListRow(
                    title: "Общий объем производства",
                    subtitle: "все продукты имеют вес нетто => общий вес",
                    detail: "плюс в штуках для того, что считатся в штуках и общий вес того что по весу",
                    icon: "scalemass"
                )
                ListRow(
                    title: "Производственные затраты",
                    subtitle: "Сырье и материалы, работа, энергия, амортизация оборудования и др.",
                    detail: "monthly",
                    icon: "dollarsign.circle"
                )
            }
            
            GenericListSection(title: "Base Products", fetchRequest: _bases) { base in
                BaseView(base)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Bases")
        .navigationBarItems(trailing: PlusButton(parent: factory, path: "bases_", keyPath: \Base.factory!))
    }
}

