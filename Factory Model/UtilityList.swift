//
//  UtilityList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct UtilityList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest private var utilities: FetchedResults<Utility>
    
    var base: Base
    
    init(for base: Base, predicate: NSPredicate? = nil) {
        self.base = base
        _utilities = Utility.defaultFetchRequest(with: predicate)
    }
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                Group {
                    LabelWithDetail("Utility Total, ex VAT", base.totalUtilitiesExVAT.formattedGrouped)
                    LabelWithDetail("Utility Total, incl VAT", base.totalUtilitiesWithVAT.formattedGrouped)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            Section(header: Text("Utilities")) {
                ForEach(utilities, id: \.objectID) { utility in
                    NavigationLink(
                        destination: UtilityView(utility)
                    ) {
                        ListRow(utility)
                    }
                }
                .onDelete(perform: removeUtility)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(base.name)
        .navigationBarItems(trailing: plusButton)
    }
    
    //  MARK: - can't replace with PlusEntityButton: addToUtilities_
    private var plusButton: some View {
        Button {
            let utility = Utility(context: moc)
            utility.name = " ..."
            utility.priceExVAT = 10
            base.addToUtilities_(utility)
            moc.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeUtility(at offsets: IndexSet) {
        for index in offsets {
            let util = utilities[index]
            moc.delete(util)
        }
        moc.saveContext()
    }
}
