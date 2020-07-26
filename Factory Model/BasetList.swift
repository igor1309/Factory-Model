//
//  BaseList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct BaseList: View {
    @Environment(\.managedObjectContext) var сontext
    
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
                format: "factory = %@", factory
            )
        )
    }
    
    var body: some View {
        List {
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
            
            Section(header: Text("Total")) {
                Group {
                    LabelWithDetail("bag", "Total Baseion Cost**", factory.totalCostExVAT.formattedGrouped)
                    
                    Text("ЕЩЕ не совсем кост — не всё учтено!!!")
                        .foregroundColor(.systemRed)
                        .font(.caption)
                    
                    LabelWithDetail("cart", "Total Revenue", factory.revenueExVAT.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(header: Text("Base Groups")) {
                ForEach(factory.baseGroupsAsRows) { baseGroup in
                    NavigationLink(
                        destination: BaseGroupList(group: baseGroup.title, at: factory)
                    ) {
                        ListRow(baseGroup)
                    }
                }
            }
            
            Section(header: Text("Base Products")) {
                ForEach(bases, id: \.objectID) { base in
                    NavigationLink(
                        destination: BaseView(base)
                    ) {
                        ListRow(base)
                    }
                }
                .onDelete(perform: removeBase)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Bases")
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let base = Base(context: сontext)
            base.name = " New Base"
            factory.addToBases_(base)
            сontext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeBase(at offsets: IndexSet) {
        for index in offsets {
            let base = bases[index]
            сontext.delete(base)
        }
        
        сontext.saveContext()
    }
}
