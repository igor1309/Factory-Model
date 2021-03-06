//
//  BaseList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct BaseGroupList: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject private var settings: Settings
    
    @ObservedObject var factory: Factory
    let group: String
    
    @FetchRequest private var bases: FetchedResults<Base>
    
    init(group: String, at factory: Factory) {
        self.factory = factory
        self.group = group
        
        let predicate = NSCompoundPredicate(
            type: .and,
            subpredicates: [
                NSPredicate(format: "%K == %@", #keyPath(Base.factory), factory),
                NSPredicate(format: "%K == %@", #keyPath(Base.group_), group)
            ]
        )
        _bases = Base.defaultFetchRequest(with: predicate)
    }
    
    var body: some View {
        List {
            Section(header: Text("Group Totals")) {
                Group {
                    LabelWithDetail("square", "Production", "TBD")
                    
                    LabelWithDetail(Sales.icon, "Revenue, ex VAT", factory.revenueExVAT(of: group, in: settings.period).formattedGrouped)
                }
                .font(.subheadline)
                .padding(.vertical, 3)
            }
            
            Section(header: Text("Bases")) {
                ForEach(bases, id: \.objectID) { base in
                    NavigationLink(
                        destination: BaseView(base)
                    ) {
                        EntityRow(base)
                    }
                }
                .onDelete(perform: removeBase)
                
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(group)
        .navigationBarItems(trailing: plusButton)
    }
    
    //  MARK: - can't replace with PlusEntityButton: base.group = group
    private var plusButton: some View {
        Button {
            let haptics = Haptics()
            haptics.feedback()
            
            withAnimation {
                let base = Base(context: context)
                base.name = " New Base"
                //            base.note = "Some note for base"
                // base.code = "1001"
                base.group = group
                base.complexity = 1
                factory.addToBases_(base)
                context.saveContext()
            }
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeBase(at offsets: IndexSet) {
        for index in offsets {
            let base = bases[index]
            context.delete(base)
        }
        context.saveContext()
    }
}
