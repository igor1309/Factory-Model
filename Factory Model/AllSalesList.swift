//
//  AllSalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI
import SwiftPI

struct AllSalesList: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest private var sales: FetchedResults<Sales>
    @FetchRequest private var orphans: FetchedResults<Sales>

//    @ObservedObject
    var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
        _sales = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
                NSSortDescriptor(keyPath: \Sales.priceExVAT, ascending: true)
            ],
            predicate: Sales.factoryPredicate(for: factory)
        )
        _orphans = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
                NSSortDescriptor(keyPath: \Sales.priceExVAT, ascending: true)
            ]
        )
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Total"),
                footer: Text("To edit Sales go to Product")
            ) {
                LabelWithDetail("creditcard.fill", "Total revenue, ex VAT", factory.revenueExVAT.formattedGrouped)
                    .foregroundColor(.systemGreen)
                    .font(.subheadline)

                ListRow(
                    title: "Общие Продажи",
                    subtitle: "Деньги (выручка и маржа, маржинальность) и объемы",
                    detail: "",
                    icon: "creditcard"
                )
                
                ListRow(
                    title: "Продажи по покупателям",
                    subtitle: "Деньги (выручка и маржа, маржинальность) и объемы",
                    detail: "По Product и по Product",
                    icon: "creditcard"
                )
                
                ListRow(
                    title: "Продажи по продуктам",
                    subtitle: "Деньги (выручка и маржа, маржинальность), средние цены, объемы и штуки",
                    detail: "По Product и по Product",
                    icon: "creditcard"
                )
            }
            
            GenericListSection(fetchRequest: _sales) { sales in
                SalesEditor(sales: sales)
            }
            
            GenericListSection(fetchRequest: _orphans) { sales in
                SalesEditor(sales: sales)
            }
            
            Section(header: Text("Sales")) {
                ForEach(sales, id: \.objectID) { sales in
                    
                    NavigationLink(
                        destination: SalesEditor(sales: sales)
                    ) {
                        ListRow(sales)
                    }
                }
                .onDelete(perform: removeSales)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Sales")
        .navigationBarItems(trailing: plusButton)
    }
    
    //  MARK: - can't replace with PlusEntityButton: linked entities
    private var plusButton: some View {
        Button {
            let buyer = Buyer(context: context)
            buyer.name = " John"
            
            let sales = Sales(context: context)
            sales.buyer = buyer
            sales.qty = 1_000
            sales.priceExVAT = 300
            
            context.saveContext()
        } label: {
            Image(systemName: "plus")
                .padding([.leading, .vertical])
        }
    }

    private func removeSales(at offsets: IndexSet) {
        for index in offsets {
            let sale = sales[index]
            context.delete(sale)
        }
        
        context.saveContext()
    }
}

