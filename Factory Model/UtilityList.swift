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
                
                HStack {
                    Text("Utility Total")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(product.totalUtilities, specifier: "%.f")")
                }
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
            product.addToUtilities_(utility)
            save()
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
        
        save()
    }
    
    private func save() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // handle the Core Data error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//struct UtilityList_Previews: PreviewProvider {
//    static var previews: some View {
//        UtilityList()
//    }
//}
