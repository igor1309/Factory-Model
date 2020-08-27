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
    
    init(_ buyer: Buyer){
        self.buyer = buyer
    }
    
    var body: some View {
        ListWithDashboard(
            for: buyer,
            title: "Edit Buyer",
            predicate: NSPredicate(format: "%K == %@", #keyPath(Sales.buyer), buyer)
        ) {
            CreateChildButton(
                systemName: "cart",
                childType: Sales.self,
                parent: buyer,
                keyPath: \Buyer.sales_
            )
        } dashboard: {
            Section(
                header: Text("Buyer Detail")
            ) {
                NavigationLink(
                    destination: BuyerEditor(buyer)
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
            SalesEditor(sales)
        }
    }
}
