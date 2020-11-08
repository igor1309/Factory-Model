//
//  BuyerEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct BuyerView: View {
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var buyer: Buyer
    
    init(_ buyer: Buyer) {
        self.buyer = buyer
        
        predicate = NSPredicate(format: "%K == %@", #keyPath(Sales.buyer), buyer)
    }
    
    private let predicate: NSPredicate
    
    var body: some View {
        ListWithDashboard(
            for: buyer,
            title: "Edit Buyer",
            predicate: predicate
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
                    destination: BuyerEditor(buyer)
                ) {
                    ListRow(buyer, period: settings.period)
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

struct BuyerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BuyerView(Buyer.example)
        }
        .environment(\.managedObjectContext, PersistenceManager.previewContext)
        .environmentObject(Settings())
        .preferredColorScheme(.dark)

    }
}
