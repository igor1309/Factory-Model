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
            Section(header: Text("Utility Total".uppercased())) {
                
                HStack {
                    Text("Utility Total")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("TBD\(100, specifier: "%.f")")
                }
                .font(.subheadline)
            }
            
            Section(header: Text("Utility".uppercased())) {
                ForEach(utility, id: \.self) { utility in
                    NavigationLink(
                        destination: UtilityView(utility)
                    ) {
                        ListRow(title: utility.name,
                                subtitle: "\(utility.price)",
                                icon: "lightbulb")
                    }
                }
                .onDelete(perform: removeUtility)
                
                Button("Add Utility") {
                    let utility = Utility(context: managedObjectContext)
                    //utility.name = "New Utility"
                    //utility.note = "Some note regarding new utility"
                    //                    utility.division = division
                    //utility.department = "..."
                    //utility.position = "Worker"
                    utility.name = "Электроэнергия"
                    product.addToUtilities_(utility)
                    save()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(product.name)
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
