//
//  AllSalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI
import SwiftPI

struct AllSalesList: View {
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory

        _orphans = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
                NSSortDescriptor(keyPath: \Sales.priceExVAT, ascending: true)
            ],
            predicate: Sales.orphanPredicate
        )
    }
    
    @FetchRequest private var orphans: FetchedResults<Sales>
    
    var body: some View {
        List {
            Section(
                header: Text("Total"),
                footer: Text("To edit Sales go to Product.")
            ) {
                LabelWithDetail("creditcard.fill", "Revenue, ex VAT", factory.revenueExVAT(in: settings.period).formattedGrouped)
                    .foregroundColor(.systemGreen)
                    .font(.subheadline)
                
                ListRow(
                    title: "TBD: Общие Продажи",
                    subtitle: "TBD: Деньги (выручка и маржа, маржинальность) и объемы",
                    detail: "TBD: ",
                    icon: "creditcard"
                )
                
                ListRow(
                    title: "TBD: Продажи по покупателям",
                    subtitle: "TBD: Деньги (выручка и маржа, маржинальность) и объемы",
                    detail: "TBD: По Product и по Product",
                    icon: "creditcard"
                )
                
                ListRow(
                    title: "TBD: Продажи по продуктам",
                    subtitle: "TBD: Деньги (выручка и маржа, маржинальность), средние цены, объемы и штуки",
                    detail: "TBD: По Product и по Product Base",
                    icon: "creditcard"
                )
            }
            
            GenericListSection(type: Sales.self, predicate: Sales.factoryPredicate(for: factory))
            
            if !orphans.isEmpty {
                GenericListSection(header: "Sales and Orphans", fetchRequest: _orphans)
                .foregroundColor(.systemRed)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Sales")
        .navigationBarItems(trailing: CreateNewEntityBarButton<Sales>())
        //        .navigationBarItems(trailing: plusButton)
    }
    
    //  MARK: - can't replace with PlusEntityButton: linked entities
    //    private var plusButton: some View {
    //        Button {
    //            let buyer = Buyer(context: context)
    //            buyer.name = " John"
    //
    //            let sales = Sales(context: context)
    //            sales.buyer = buyer
    //            sales.qty = 1_000
    //            sales.priceExVAT = 300
    //
    //            context.saveContext()
    //        } label: {
    //            Image(systemName: "plus")
    //                .padding([.leading, .vertical])
    //        }
    //    }
}


struct AllSalesList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllSalesList(for: Factory.example)
                .environment(\.managedObjectContext, PersistenceManager.previewContext)
                .environmentObject(Settings())
                .preferredColorScheme(.dark)
        }
    }
}
