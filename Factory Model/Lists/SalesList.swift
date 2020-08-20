//
//  SalesList.swift
//  Factory Model
//
//  Created by Igor Malyarov on 21.07.2020.
//

import SwiftUI

struct SalesList: View {
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var product: Product
    
    init(for product: Product) {
        self.product = product
    }
    
    var body: some View {
        ListWithDashboard(
            for: product,
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Sales.product), product
            )
        ) {
            CreateChildButton(
                systemName: "cart.badge.plus",
                childType: Sales.self,
                parent: product,
                keyPath: \Product.sales_
            )
        } dashboard: {
            ListRow(
                title: "TBD: Продажи по продукту",
                subtitle: "TBD: Деньги (выручка и маржа, маржинальность), средние цены, объемы и штуки",
                detail: "TBD: По Product и по Product Base(?)",
                icon: "creditcard"
            )
        } editor: { (sales: Sales) in
            SalesEditor(sales)
        }
    }
}
