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
                header: Text("Name")
            ) {
                TextField("Name", text: $buyer.name)
                    .foregroundColor(.accentColor)
            }
            
            if buyer.factory == nil {
                Section(
                    header: Text("Factory ERROR")
                ) {
                    EntityPicker(selection: $buyer.factory, icon: "building.2")
                }
                .foregroundColor(.systemRed)
            }
        } editor: { (sales: Sales) in
            SalesView(sales)
        }
    }
}
