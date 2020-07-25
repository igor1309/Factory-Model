//
//  BaseList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct BaseGroupList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest private var bases: FetchedResults<Base>
    
    @ObservedObject var factory: Factory
    let group: String
    
    init(group: String, at factory: Factory) {
        self.factory = factory
        self.group = group
        _bases = FetchRequest(
            entity: Base.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Base.name_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "factory = %@ and group_ = %@", factory, group
            )
        )
    }
    
    var body: some View {
        List {
            Section(header: Text("Group Totals")) {
                Group {
                    LabelWithDetail("bag", "Baseion", "TBD")
                    
                    LabelWithDetail("dollarsign.circle", "Revenue, ex VAT", factory.revenueExVAT(for: group).formattedGrouped)
                }
                .font(.subheadline)
                .padding(.vertical, 3)
            }
            
            Section(header: Text("Bases")) {
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
        .navigationTitle(group)
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let base = Base(context: managedObjectContext)
            base.name = " New Base"
//            base.note = "Some note for base"
            // base.code = "1001"
            base.group = group
            factory.addToBases_(base)
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeBase(at offsets: IndexSet) {
        for index in offsets {
            let base = bases[index]
            managedObjectContext.delete(base)
        }
        
        managedObjectContext.saveContext()
    }
}

//struct BaseList_Previews: PreviewProvider {
//    static var previews: some View {
//        BaseList(group: <#String#>, at: <#Factory#>)
//    }
//}
