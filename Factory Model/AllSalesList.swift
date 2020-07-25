//
//  AllSalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI
import SwiftPI

struct AllSalesList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest private var sales: FetchedResults<Sales>
    
    @ObservedObject var factory: Factory
    
    init(for factory: Factory) {
        self.factory = factory
        _sales = FetchRequest(
            entity: Sales.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Sales.qty, ascending: true),
                NSSortDescriptor(keyPath: \Sales.buyer_, ascending: true)
            ],
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Sales.packaging.factory), factory
            )
        )
    }
    
    var body: some View {
        List {
            Section(
                header: Text("Total"),
                footer: Text("To edit Sales go to Packaging")
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
                    detail: "По Packaging и по Product",
                    icon: "creditcard"
                )
                
                ListRow(
                    title: "Продажи по продуктам",
                    subtitle: "Деньги (выручка и маржа, маржинальность), средние цены, объемы и штуки",
                    detail: "По Packaging и по Product",
                    icon: "creditcard"
                )
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
    }
    
    private func removeSales(at offsets: IndexSet) {
        for index in offsets {
            let sale = sales[index]
            managedObjectContext.delete(sale)
        }
        
        managedObjectContext.saveContext()
    }
}

