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
    
    let period: Period
    
    init(for product: Product, in period: Period) {
        self.product = product
        self.period = period
    }
    
    var body: some View {
        ListWithDashboard(
            for: product,
            predicate: NSPredicate(
                format: "%K == %@", #keyPath(Sales.product), product
            ),
            in: period
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
            SalesEditor(sales, in: period)
        }
    }
}

struct SalesList_Previews: PreviewProvider {
    static let period: Period = .month()
    
    static var previews: some View {
        NavigationView {
            SalesList(for: PersistenceManager.productPreview, in: period)
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, PersistenceManager.preview)
        }
    }
}
