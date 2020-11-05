//
//  BuyerEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct BuyerView: View {
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var buyer: Buyer
    
    let period: Period
    
    init(_ buyer: Buyer, in period: Period) {
        self.buyer = buyer
        self.period = period
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(Sales.buyer), buyer)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            for: buyer,
            title: "Edit Buyer",
            predicate: predicate,
            in: period
        ) {
            CreateChildButton(
                childType: Sales.self,
                parent: buyer,
                keyPath: \Buyer.sales_
            )
        } dashboard: {
            Section(
                header: Text("Buyer Detail")
            ) {
                NavigationLink(
                    destination: BuyerEditor(buyer, in: period)
                ) {
                    ListRow(buyer)
                }
            }
            
            ErrorMessage(buyer)
            
            Section(
                header: Text("Total Sales")
            ) {
                Text("TBD: Sales volumes and amount for the Buyer, list of Products")
                    .foregroundColor(.systemRed)
            }
        } editor: { (sales: Sales) in
            SalesEditor(sales, in: period)
        }
    }
}

struct BuyerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BuyerView(Buyer.preview, in: .month())
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .preferredColorScheme(.dark)

    }
}
