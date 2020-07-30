//
//  BuyerEditor.swift
//  Factory Model
//
//  Created by Igor Malyarov on 30.07.2020.
//

import SwiftUI

struct BuyerEditor: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentation
    
    @ObservedObject var buyer: Buyer
    
    init(_ buyer: Buyer){
        self.buyer = buyer
    }
    
    var body: some View {
        ListWithDashboard(
            title: "Edit Buyer",
            parent: buyer,
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
                header: Text("Name")
            ) {
                TextField("Name", text: $buyer.name)
                    .foregroundColor(.accentColor)
            }
        } editor: { (sales: Sales) in
            SalesEditor(sales)
        }
        
    }
}
