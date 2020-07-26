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
        _bases = FetchRequest(
            entity: Base.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Base.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Base.factory), factory
            )
        )
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Base Groups"),
                footer: Text("TBD: How to change to fetch request?")
            ) {
                ForEach(factory.baseGroupsAsRows) { baseGroup in
                    NavigationLink(
                        destination: BaseGroupList(group: baseGroup.title, at: factory)
                    ) {
                        ListRow(baseGroup)
                    }
                }
            }
            
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
            
            GenericSection("Base Products", _bases) { base in
                BaseView(base)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Bases")
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let base = Base(context: moc)
            base.name = " New Base"
            factory.addToBases_(base)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
}
