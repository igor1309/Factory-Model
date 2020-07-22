//
//  UtilityList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct UtilityList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var utility: FetchedResults<Utility>
    
    let product: Product
    
    init(for product: Product) {
        self.product = product
        _utility = FetchRequest(
            entity: Utility.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Utility.name_, ascending: true),
                NSSortDescriptor(keyPath: \Utility.price, ascending: true)
            ],
            predicate: NSPredicate(
                format: "product = %@", product
            )
        )
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Total")) {
                LabelWithDetail("Utility Total", product.totalUtilities.formattedGroupedWith1Decimal)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Section(header: Text("Utilities")) {
                ForEach(utility, id: \.self) { utility in
                    NavigationLink(
                        destination: UtilityView(utility)
                    ) {
                        ListRow(
                            title: utility.name,
                            subtitle: "\(utility.price)",
                            icon: "lightbulb",
                            useSmallerFont: true
                        )
                    }
                }
                .onDelete(perform: removeUtility)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.name)
        .navigationBarItems(trailing: plusButton)
    }
    
    private var plusButton: some View {
        Button {
            let utility = Utility(context: managedObjectContext)
            utility.name = " ..."
            utility.price = 10
            product.addToUtilities_(utility)
            managedObjectContext.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }
    
    private func removeUtility(at offsets: IndexSet) {
        for index in offsets {
            let util = utility[index]
            managedObjectContext.delete(util)
        }
        
        managedObjectContext.saveContext()
    }
}

//struct UtilityList_Previews: PreviewProvider {
//    static var previews: some View {
//        UtilityList()
//    }
//}
